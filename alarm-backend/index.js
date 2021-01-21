import express from "express";
import alarmRoutes from "./routes/alarmRoutes.js";
import { config } from "dotenv";
import connectDB from "./config/mongoDbConfig.js";
import { errorHandling } from "./middleware/errorHandler.js";
config();
connectDB();
const app = express();
app.use(express.json());
app.use("/alarm", alarmRoutes);
app.use(errorHandling);

const PORT = process.env.PORT || 5000;

app.listen(
  PORT,
  console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`)
);
