import os, json, sqlite3
import google.generativeai as genai
from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import markdown
from youtube_search import YoutubeSearch
from googleapiclient.discovery import build
from bs4 import BeautifulSoup
import re
from twilio.rest import Client

app = Flask(__name__)
CORS(app)
API_KEY = "AIzaSyDA61NPgV6EOvsUskUgWrZJIanUxTPXlwA"
YOUTUBE_API_KEY = "AIzaSyDA61NPgV6EOvsUskUgWrZJIanUxTPXlwA"

genai.configure(api_key=API_KEY)

# def upload_to_gemini(path, mime_type=None):
#   file = genai.upload_file(path, mime_type=mime_type)
#   print(f"Uploaded file '{file.display_name}' as: {file.uri}")
#   return file

# Create the model
generation_config = {
  "temperature": 1,
  "top_p": 0.95,
  "top_k": 64,
  "max_output_tokens": 8192,
  "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
  model_name="gemini-1.5-flash",
  generation_config=generation_config,
)
# "C:/Users/Soham Daddikar/Desktop/Handicraft-Desktop-Wallpaper-25437 (1).jpg"
# "C:/Users/Soham Daddikar/Desktop/handicraft_test_1.jpeg"
# "C:/Users/Soham Daddikar/Desktop/handicraft_test_2.jpeg"
# "C:/Users/Soham Daddikar/Desktop/floral_shirt.jpg"
# --- Upload Function ---
def upload_to_gemini(path, mime_type=None):
    file = genai.upload_file(path, mime_type=mime_type)
    print(f"Uploaded file '{file.display_name}' as: {file.uri}")
    return file

# --- Database (optional, if needed later) ---
conn = sqlite3.connect('learnempower.db', check_same_thread=False)

# --- Main Route ---
@app.route('/', methods=['POST'])
def characters():
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    image = request.files['image']

    # Save temporarily
    save_path = os.path.join("uploads", image.filename)
    os.makedirs("uploads", exist_ok=True)
    image.save(save_path)

    # Upload to Gemini
    gemini_file = upload_to_gemini(save_path, mime_type="image/jpeg")

    # Ask the model
    chat = model.start_chat()
    prompt = f"""Given this image:
    
1. Detail the type of the particular handicraft or other work (like ) in which I only want the design characteristics (like ceramic, floral, etc. in single word) of that handicraft in short in JSON format."""

    response = chat.send_message([gemini_file, prompt])

    # Delete the file if you want
    os.remove(save_path)

    return jsonify({"response": response.text})

def remove_markdown(text):
    # Convert markdown to HTML
    html = markdown.markdown(text)
    # Parse the HTML to strip tags
    soup = BeautifulSoup(html, "html.parser")
    # Get the plain text
    plain_text = soup.get_text()
    # Split into lines, remove extra spaces from each line, and then rejoin with line breaks
    cleaned_lines = [line.strip() for line in plain_text.splitlines() if line.strip()]  # Removes empty lines too
    return '\n'.join(cleaned_lines)  # Join the cleaned lines with line breaks
  
def respond_pay(user, employer_map):
    prompt = f'I am giving you user skills which are: {user} that they can do and I am also giving you a mapping of the skills that employer needs with the price (in rupees) he will give for that job which are: {employer_map} and what you have to do is take these two things and give me what the user have to learn for that job with the price of the job. Then detail the output should be drectly the gaps and the pay in string format as proper sentence and include the actual user skills which are given in the start can be different you have to give the output according to the starting ones. In repsonse, only give the sentence that will be for the output in plain text'
    
    response = model.generate_content(prompt)
    
    if hasattr(response, 'text'):
        clean_text = remove_markdown(response.text)
        
        lines = [line.strip() for line in clean_text.splitlines() if line.strip()]
        single_sentence = ' '.join(lines).replace('/', '')
        
        return single_sentence
    
    return []
  
def roadmap_info(combined_sentence):
    prompt = f'I am giving you various requirements for different amount payable jobs which is {combined_sentence}. And I want you to make a roadmap so that the user can take those jobs step by step. Give the roadmap and steps to learn each skill in the roadmap. Give the response in plain text.'
    
    response = model.generate_content(prompt)
    
    if hasattr(response, 'text'):
        clean_text = remove_markdown(response.text)
        
        phases = re.split(r'(Phase\s*\d+:)', clean_text)
        # Combine split parts into a dictionary
        phase_dict = {}
        current_phase = ""
        
        for part in phases:
            part = part.strip()
            if re.match(r'^Phase\s*\d+:$', part):
                current_phase = part.lower().replace(" ", "-").strip(":")
            elif current_phase:
                phase_dict[current_phase] = part
                current_phase = ""

        return phase_dict
    
    return {}
  
def language_explain(language):
  prompt = f'I am giving you the content on the page which is {language}. I want you to analyse this content and explain it to a naive user and the response should be in the same language which is on the page.'
  
  response = model.generate_content(prompt)
  
  if hasattr(response, 'text'):
      clean_text = remove_markdown(response.text)
      
      """ lines = [line.strip() for line in clean_text.splitlines() if line.strip()]
      single_sentence = ' '.join(lines).replace('/', '') """
      
      return clean_text
  
  return []
  
@app.route('/compare', methods = ['GET', 'POST'])
def compare():
    data = request.json
    user = data.get("user")
    employer_map = data.get("employer_map")
    #user = request.form["user"]
    #employer_map = request.form["employer_map"]
    
    response = respond_pay(user, employer_map)
    
    print(response)
    return jsonify({"response": response})
  
def get_youtube_video(query):
    # Build the YouTube API service
    youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)
    
    # Perform the search using the YouTube API
    request = youtube.search().list(
        part='snippet',
        q=query,
        maxResults=3,  # Set maxResults to 3 to get the top 3 results
        type='video'   # Ensure we're searching for videos only
    )
    response = request.execute()
    
    # Parse the response and extract video information
    video_urls = []
    if response['items']:
        for item in response['items']:
            video_id = item['id']['videoId']
            video_url = f'https://www.youtube.com/watch?v={video_id}'
            video_urls.append(video_url)
    return video_urls
      
@app.route('/embed_vid', methods = ['POST', 'GET'])
def show_vid():
    data = request.json
    lesson = data.get("learn")
    category = data.get("category")
    
    #lesson = "floral"
    #category = "handicraft"
    
    query = f"how to learn {lesson} in category {category}"
    
    original_video_urls = get_youtube_video(query)

    embedded_urls = []
    
    for urls in original_video_urls:  
      if "youtube.com/watch?v=" in urls:
          video_id = urls.split("v=")[-1]
          video_url = f"https://www.youtube.com/embed/{video_id}"
          embedded_urls.append(video_url)
      else:
          video_url = urls
          embedded_urls.append(video_url)
        
    print(embedded_urls)
    
    return jsonify({"video_urls": embedded_urls})
  
  
@app.route('/info')
def info():
  data = request.json()
  combined_sentence = data.get("combined")
  
  #combined_sentence = "To get the job paying 10000 rupees, you need to learn ceramic and religious art.  Your existing floral skills are not required for this job. To get the sculpting job paying 20000 rupees, you need to learn sculpting; your existing skills of floral, abstract, and ceramic art may be helpful, but religious art is not directly relevant. To get the marble sculpting job paying 30000 rupees, you need to learn marble sculpting.  Your existing skills of sculpting are relevant, but you lack experience in marble. And seperate every phase (jobs) according to their payable amount. Like before every phase the text after that should be on the next line."
  
  response = roadmap_info(combined_sentence)
  
  print(response)
  
  return jsonify({"info": response})

@app.route('/language', methods = ['GET', 'POST'])
def language():
  data = request.json
  displayed_content = data.get("content")
  
  #displayed_content = request.form['content']
  
  response = language_explain(displayed_content)
  
  print(response)
  
  return jsonify({"explain" : response})


@app.route('/validate-domain', methods=['POST'])
def validate_domain():
    domain = request.json.get('domain', '')
    prompt = (
        f"Check if '{domain}' is a recognized career domain in India. "
        "Return exactly {\"valid\": true} or {\"valid\": false}."
    )
    resp = model.generate_content(prompt)
    try:
        return jsonify(json.loads(resp.text))
    except:
        return jsonify({"valid": False})
    
def gem_chat(query):
    prompt = f'{query}'
    
    response = model.generate_content(prompt)
    
    if hasattr(response, 'text'):
        clean_text = remove_markdown(response.text)
        
        lines = [line.strip() for line in clean_text.splitlines() if line.strip()]
        single_sentence = ' '.join(lines).replace('/', '')
        
        return single_sentence
    
    return []
    
@app.route('/chatbot', methods = ['GET', 'POST'])
def chatbot():
    data = request.json
    query = data.get('query')
    #query = request.form['query']
    
    response = gem_chat(query)
    
    print(response)
    
    return jsonify({"response": response})
    

@app.route('/list-domains', methods=['GET'])
def list_domains():
    prompt = (
        "You are a JSON-only assistant. List 10 popular career domains in India. "
        "Return exactly a JSON array like: [\"Domain1\", \"Domain2\", ...]. Ensure that you validate those domains if those are a recognized career in India. If a domain is not a recognized career in India then don't give that one in the response."
    )
    resp = model.generate_content(prompt)
    try:
        raw_text = resp.text
        if raw_text.startswith("```") and raw_text.endswith("```"):
            raw_text = raw_text.strip("`").strip("json").strip()
        return jsonify(json.loads(raw_text))
    except:
        return jsonify([])

@app.route('/predict-skills', methods=['POST'])
def predict_skills():
    domain = request.json.get('domain', '')
    prompt = (
        f"You are an API. Respond ONLY with raw JSON array. "
        f"What are the top 5 skills required in the '{domain}' domain in India? "
        f"Return only a JSON array like: [\"Skill1\", \"Skill2\", ...]. Ensure that you validate those domains if those are a recognized career in India. If a domain is not a recognized career in India then don't give that one in the response." 
    )
    resp = model.generate_content(prompt)
    raw_text = resp.text
    # Remove markdown code block formatting if present
    if raw_text.startswith("```") and raw_text.endswith("```"):
        raw_text = raw_text.strip("`").strip("json").strip()
    try:
        return jsonify(json.loads(raw_text))
    except:
        return jsonify([])

@app.route('/match-jobs', methods=['POST'])
def match_jobs():
    data = request.json
    domain = data.get('domain', '')
    
    prompt = (
      f"You are a JSON-only job recommendation assistant for India.\n"
      f"Domain: {domain}\n"
      "Return exactly a JSON array of objects with keys 'title','company','required_skills','match_percentage'."
      "Include 5 job opportunities. Ensure that you validate those domains if those are a recognized career in India. If a domain is not a recognized career in India then don't give that one in the response."
    )

    # Configure generation parameters
    from google.generativeai import GenerationConfig
    gen_config = GenerationConfig(temperature=0.2, max_output_tokens=512)

    # Retry up to 3 times if empty
    for _ in range(3):
        resp = model.generate_content(prompt, generation_config=gen_config)
        raw_text = resp.text.strip()
        
        # Remove markdown code block formatting if present
        if raw_text.startswith("```") and raw_text.endswith("```"):
            raw_text = raw_text.strip("`").strip("json").strip()
        
        try:
            jobs = json.loads(raw_text)
            return jsonify(jobs)
        except Exception:
            continue
    
    return jsonify([])
    
@app.route('/suggest-interests', methods=['POST'])
def suggest_interests():
    # Get JSON body
    data = request.get_json(silent=True)
    if not data:
        return jsonify({'error': 'Request must be JSON with an "interests" list'}), 400

    # Validate "interests" field
    interests = data.get('interests')
    if not isinstance(interests, list):
        return jsonify({'error': '"interests" must be a JSON array'}), 400

    # Build prompt
    interests_str = ', '.join(interests)
    prompt = (
        f"You are a JSON-only assistant. "
        f"Based on these interests: {interests_str}, return exactly a JSON object with keys:\n"
        "  domains (array of strings),\n"
        "  skills (array of strings),\n"
        "  jobs (array of strings).\n"
        "Do not include any extra text or formatting."
    )

    # Call Gemini
    resp = model.generate_content(prompt)
    raw = resp.text.strip()

    # Strip code fences if present
    if raw.startswith("```") and raw.endswith("```"):
        raw = raw.strip("`").replace("json", "").strip()

    # Parse JSON or fallback to empty dict
    try:
        result = json.loads(raw)
        # ensure keys exist and are lists
        return jsonify({
            'domains': result.get('domains', []),
            'skills':  result.get('skills',  []),
            'jobs':    result.get('jobs',    [])
        })
    except Exception as e:
        print("❌ suggest-interests JSON parse error:", e, "\nRaw response:", raw)
        return jsonify({}), 200

@app.route('/answer-domain-question', methods=['POST'])
def answer_domain_question():
    data = request.get_json(silent=True)
    if not data:
        return jsonify({'error': 'Request must be JSON'}), 400
        
    domain = data.get('domain', '')
    question = data.get('question', '')
    
    prompt = (
        f"You are a career advisor with expertise in the {domain} domain in India. "
        f"Answer the following question clearly and concisely: {question}"
    )
    
    resp = model.generate_content(prompt)
    return jsonify({"answer": resp.text})

if __name__ == "__main__":
  app.run(debug = True, host='0.0.0.0', port=8000)