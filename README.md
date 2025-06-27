# Product Management System

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)

A complete product management solution with:
- **Backend**: Node.js + Express + MongoDB API
- **Mobile App**: Flutter (Android/iOS)

## Project Structure

- product-api/ # Backend server
-  product-mobile/ # Flutter app
  

## 🛠️ Backend Setup

### Requirements
- Node.js v18+
- MongoDB (local or Atlas)

1. Enter backend folder:
   
   cd product-api
   
3. Install Packages
   
   npm install

5. Create .env file
   
    MONGO_URI=mongodb://localhost:27017/product_db
   
    PORT=5000

6. Start server

   npm run dev

##📱 Mobile App Setup

1. Enter app folder

   cd product-mobile

2. Get dependencies

   flutter pub get

3. Configure API URL in (lib/api/api_service.dart)

   baseUrl = 'http://10.0.2.2:5000/api';   (your ip address)

4. Run app

   flutter run

