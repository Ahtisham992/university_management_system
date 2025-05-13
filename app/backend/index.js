const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const app = express();
const Routes = require("./routes/route.js");

const analyticsRoutes = require('./routes/analyticsRoutes');
const assignmentRoutes = require('./routes/assignmentRoutes');
const attendanceRoutes = require('./routes/attendanceRoutes');
const feeRoutes = require('./routes/feeRoutes');
const courseRoutes = require('./routes/courseRoutes');
const gradesRoutes = require('./routes/gradesRoutes');
const gradingRoutes = require('./routes/gradingRoutes');
const materialRoutes = require('./routes/materialRoutes');
const performanceRoutes = require('./routes/performanceRoutes');
const progressReportRoutes = require('./routes/progressReportRoutes');
const reportRoutes = require('./routes/reportRoutes');
const scheduleRoutes = require('./routes/scheduleRoutes');
const syllabusRoutes = require('./routes/syllabusRoutes');
const communicationRoutes = require('./routes/communicationRoutes');
const quizRoutes = require('./routes/quizRoutes');
const quizAssessmentRoutes = require('./routes/quizAssessmentRoutes');
const scholarshipRoutes = require('./routes/scholarshipRoutes');

// Load environment variables
dotenv.config();

const PORT = 3000;

// CORS Configuration - Allow all origins
// This configuration accepts connections from any frontend
const corsOptions = {
  origin: '*', // Allow all origins
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

// Request logger middleware
app.use((req, res, next) => {
  console.log({ method: req.method, path: req.url });
  next();
});

// Apply middleware
app.use(express.json({ limit: '10mb' }));
app.use(cors(corsOptions));

// Define database connection
const connectToDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("Connected to MongoDB");
    return true;
  } catch (err) {
    console.log("MongoDB connection error:", err);
    return false;
  }
};

// API routes
app.use('/api/analytics', analyticsRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/course', courseRoutes);
app.use('/api/grades', gradesRoutes);
app.use('/api/material', materialRoutes);
app.use('/api/performance', performanceRoutes);
app.use('/api/progressReports', progressReportRoutes);
app.use('/api/fee', feeRoutes);
app.use('/api/report', reportRoutes);
app.use('/api/schedule', scheduleRoutes);
app.use('/api/syllabus', syllabusRoutes);
app.use('/api/assignment', assignmentRoutes);
app.use('/api/communication', communicationRoutes);
app.use('/api/quiz', quizRoutes);
app.use('/api/quizAssessment', quizAssessmentRoutes);
app.use('/api/grading', gradingRoutes);
app.use('/', Routes);

// Connect to database and start server
(async () => {
  const isConnected = await connectToDatabase();
  
  app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`);
  });
})();