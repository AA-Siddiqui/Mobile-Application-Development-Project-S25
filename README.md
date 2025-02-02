# University Management System

## Project Overview

The University Management System is a comprehensive platform designed to streamline the management of academic institutions. It provides a centralized system for administrators, teachers, and students to manage academic activities, user roles, and institutional data. The system is built using a modern tech stack, ensuring scalability, maintainability, and a seamless user experience.

### Purpose
The purpose of this project is to create a robust and user-friendly platform that simplifies the management of university operations. It enables administrators to manage user roles, courses, and institutional data, while teachers and students can access relevant information and perform their tasks efficiently. The system aims to enhance productivity, reduce manual effort, and improve communication between stakeholders.

---

## Technologies and Frameworks

### Frontend
- **Flutter**: A cross-platform framework for building natively compiled applications for mobile, web, and desktop from a single codebase. Flutter is used to create a responsive and intuitive user interface for the application.

### Backend
- **NestJS**: A progressive Node.js framework for building efficient, reliable, and scalable server-side applications. NestJS is used to create RESTful APIs and handle business logic for the system.

### Database
- **MySQL**: A relational database management system used to store and manage data for the application, including user information, course details, and academic records.

### Other Tools and Libraries
- **Dart**: The programming language used for Flutter development.
- **TypeScript**: The primary language for NestJS backend development.
- **TypeORM**: An ORM (Object-Relational Mapping) tool used to interact with the MySQL database.
- **JWT (JSON Web Tokens)**: Used for authentication and authorization.

---

## Getting Started

Follow the steps below to clone, set up, and run the project on your local machine.

### Prerequisites
- **Flutter SDK**: Ensure Flutter is installed on your machine. Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) if not already installed.
- **Node.js**: Install Node.js (version 16 or higher) from the [official website](https://nodejs.org/).
- **MySQL**: Install and set up MySQL on your machine. You can download it from the [MySQL website](https://dev.mysql.com/downloads/).
- **Git**: Ensure Git is installed for cloning the repository.

### Steps to Clone and Run the Project

1. **Clone the Repository**:
   ```bash
   git clone <link-to-this-repo>
   cd university-management-system
   ```

2. **Set Up the Backend**:
   - Navigate to the backend directory:
     ```bash
     cd backend
     ```
   - Install dependencies:
     ```bash
     npm install
     ```
   - Set up the MySQL database:
     - Create a new database in MySQL.
     - Update the `.env` file in the `backend` directory with your database credentials:
       ```env
       DATABASE_URL="mysql://username:password@localhost:3306/database_name"
       JWT_SECRET="your_jwt_secret_key"
       ```
   - Start the NestJS server:
     ```bash
     npm run start
     ```

3. **Set Up the Frontend**:
   - Navigate to the frontend directory:
     ```bash
     cd ../frontend
     ```
   - Install dependencies:
     ```bash
     flutter pub get
     ```
   - Update the API base URL in the `lib/config.dart` file to match your backend server URL:
     ```dart
     const String baseUrl = "http://localhost:3000";
     ```
   - Run the Flutter application:
     ```bash
     flutter run
     ```

4. **Access the Application**:
   - The Flutter application will launch on your connected device or emulator.
   - Use the provided login credentials for admin, teacher, and student roles to access the system.

---