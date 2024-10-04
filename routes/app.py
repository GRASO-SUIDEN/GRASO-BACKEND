from fastapi import FastAPI, HTTPException, Depends, UploadFile, File, Query, Form, Header
# from fastapi_jwt_auth import AuthJWT
# from fastapi_jwt_auth.exceptions import AuthJWTException
from middleware.profileUpload import save_profile_picture
from middleware.propertyUpload import save_property_picture
from database.db import get_db, add_profile, find_profile, add_property, get_properties
from sqlalchemy.orm import Session
from typing import List
from .schemas import Nonce, JWTResponse, VerifySignatureRequest, Profile, Property
# from web3 import Web3
import jwt
import random
import string
from datetime import datetime, timedelta
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware



app = FastAPI()
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

SECRET_KEY = "your_secret_key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# def get_nonce():
#     """Generate a nonce"""
#     return ''.join(random.choices(string.ascii_uppercase + string.digits, k=16))

# @app.post('/generate_nonce', response_model=Nonce)
# def nonce(wallet_address: str = Query(...), db: Session = Depends(get_db)):
#     """Generate a nonce"""
#     nonce = get_nonce()
#     return generate_nonce(wallet_address, nonce, db)

# def create_access_token(data: dict, expires_delta: timedelta = None):
#     """Create a new access token"""
#     to_encode = data.copy()
#     if expires_delta:
#         expire = datetime.now() + expires_delta
#     else:
#         expire = datetime.now() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#     to_encode.update({"exp": expire})
#     return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# @app.post('/verify_signature', response_model=JWTResponse)
# def verify_signature(request: VerifySignatureRequest, db: Session = Depends(get_db)):
#     """Verify a signature"""
#     wallet_address = request.wallet_address.lower()
#     signature = request.signature
#     nonce = request.nonce

#     is_valid = verify(wallet_address, nonce, signature, db)
#     if not is_valid:
#         raise HTTPException(status_code=400, detail="Invalid signature or nonce")
    
#     access_token = create_access_token(data={"sub": wallet_address})
    # return JWTResponse(access_token=access_token)

@app.post('/profile', response_model=Profile)
async def create_profile(
    firstName: str = Form(...),
    lastName: str = Form(...),
    email: str = Form(...),
    description: str = Form(...),
    occupation: str = Form(...),
    phoneNumber: str = Form(...),
    website: str = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db)):
    """Create a profile"""
    # if not authorization or not authorization.startswith("Bearer "):
    #     raise HTTPException(status_code=401, detail="Authorization token missing or invalid")
    
    # token = authorization.split(" ")[1]
    # try:
    #     payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    #     current_user = payload["sub"]
    # except jwt.ExpiredSignatureError:
    #     raise HTTPException(status_code=401, detail="Token has expired")
    # except jwt.PyJWTError:   
    #     raise HTTPException(status_code=401, detail="Invalid token")
    
    file_name, file_path = await save_profile_picture(file)
    profile_data = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "description": description,
        "occupation": occupation,
        "phoneNumber": phoneNumber,
        "website": website,
        "picture": file_path,
    }
    new_profile = add_profile(db,  **profile_data)
    response = Profile(
        id=new_profile.id,
        firstName=new_profile.firstName,
        lastName=new_profile.lastName,
        email=new_profile.email,
        description=new_profile.description,
        occupation=new_profile.occupation,
        phoneNumber=new_profile.phoneNumber,
        website=new_profile.website,
        picture=new_profile.picture,
    )
    
    return response


def construct_full_picture_url(picture_path: str, base_url: str) -> str:
    """Constructs the full URL for the profile picture."""
    return f"{base_url}{picture_path}"

@app.get('/user-profile/{profile_id}', response_model=Profile)
def get_profile(profile_id: str, db: Session = Depends(get_db)):
    """Get a profile"""

    # if not authorization or not authorization.startswith("Bearer "):
    #     raise HTTPException(status_code=401, detail="Authorization token missing or invalid")
    # token = authorization.split(" ")[1]
    # try:
    #     payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    #     current_user = payload["sub"]
    # except jwt.ExpiredSignatureError:
    #     raise HTTPException(status_code=401, detail="Token has expired")
    # except jwt.PyJWTError:
    #     raise HTTPException(status_code=401, detail="Invalid token")
    
    profile = find_profile(db, profile_id)
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    base_url = "https://web-production-58f43.up.railway.app"
    profile.picture = construct_full_picture_url(profile.picture, base_url)
    return profile

@app.post('/property', response_model=Property)
async def create_property(
    title: str = Form(...),
    description: str = Form(...),
    price: str = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db)):
    """Create a property"""
    # if not authorization or not authorization.startswith("Bearer "):
    #     raise HTTPException(status_code=401, detail="Authorization token missing or invalid")
    # token = authorization.split(" ")[1]
    # try:
    #     payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    #     current_user = payload["sub"]
    # except jwt.ExpiredSignatureError:
    #     raise HTTPException(status_code=401, detail="Token has expired")
    # except jwt.PyJWTError:
    #     raise HTTPException(status_code=401, detail="Invalid token")
    # user_id=current_user
    file_name, file_path = await save_property_picture(file)
    property_data = {
        "title": title,
        "description": description,
        "price": price,
        "image": file_path,
    }
    new_property = add_property(db, **property_data)
    return new_property

@app.get('/properties', response_model=List[Property])
def find_properties(db: Session = Depends(get_db)):
    """Get all properties"""
    # if not authorization or not authorization.startswith("Bearer "):
    #     raise HTTPException(status_code=401, detail="Authorization token missing or invalid")
    # token = authorization.split(" ")[1]
    
    # try:
    #     payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    #     current_user = payload["sub"]
    # except jwt.ExpiredSignatureError:
    #     raise HTTPException(status_code=401, detail="Token has expired")
    # except jwt.PyJWTError:
    #     raise HTTPException(status_code=401, detail="Invalid token")
    
    properties = get_properties(db)
    base_url = "https://web-production-58f43.up.railway.app"
    for property in properties:
        property.image = construct_full_picture_url(property.image, base_url)
    return properties
