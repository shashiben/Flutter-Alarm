import express from "express";
import {
  addAlarm,
  deleteAlarmById,
  getAlarmById,
  getAllAlarm,
  updateAlarmById,
} from "../controllers/alarmController.js";
const router = express.Router();
router.route("/all").get(getAllAlarm);
router.route("/addAlarm").post(addAlarm);
router
  .route("/:id")
  .delete(deleteAlarmById)
  .put(updateAlarmById)
  .get(getAlarmById);
export default router;
