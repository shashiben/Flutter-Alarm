import asyncHandler from "express-async-handler";
import AlarmModel from "../models/alarmModel.js";

const addAlarm = asyncHandler(async (req, res) => {
  console.log(req.body);
  const { title, timeStamp, alarmTime } = req.body;
  try {
    const alarm = new AlarmModel({ title, timeStamp, alarmTime });
    const createdAlarm = await alarm.save();
    res.status(200).send({ alarm: createdAlarm });
  } catch (error) {
    res.status(500);
    res.json({ message: error });
  }
});

const getAlarmById = asyncHandler(async (req, res) => {
  try {
    const alarm = await AlarmModel.findById(req.params.id);
    if (alarm) {
      res.status(200).send(alarm);
    } else {
      res.status(400);
      res.json({ message: "No Alarms Found" });
    }
  } catch (error) {
    res.status(500);
    res.json({ message: error });
  }
});
const updateAlarmById = asyncHandler(async (req, res) => {
  try {
    const { title, timeStamp, alarmTime } = req.body;
    const alarm = await AlarmModel.findById(req.params.id);
    if (alarm) {
      alarm.title = title || alarm.title;
      alarm.timeStamp = timeStamp || alarm.timeStamp;
      alarm.alarmTime = alarmTime || alarm.alarmTime;
      const updatedAlarm = await alarm.save();
      res.status(200).send({ message: "Alarm Updated", alarm: updatedAlarm });
    } else {
      res.status(400);
      res.json({ message: "No Alarm Found" });
    }
  } catch (error) {
    res.status(500);
    res.json({ message: error });
  }
});
const deleteAlarmById = asyncHandler(async (req, res) => {
  try {
    const alarm = await AlarmModel.findById(req.params.id);
    if (alarm) {
      await alarm.remove();
      res.status(200).send({ message: "Alarm Deleted" });
    } else {
      res.status(400);
      res.json({ message: "No Alarm Found" });
    }
  } catch (error) {
    res.status(500);
    res.json({ message: error });
  }
});

const getAllAlarm = asyncHandler(async (req, res) => {
  try {
    const alarms = await AlarmModel.find({
      $query: {},
      $orderby: { timeStamp: 1 },
    });
    if (alarms) {
      res.status(200).send(alarms);
    } else {
      res.status(400);
      res.json({ message: "No Alarms Found" });
    }
  } catch (error) {
    res.status(500);
    res.json({ message: error });
  }
});
export {
  addAlarm,
  getAllAlarm,
  getAlarmById,
  deleteAlarmById,
  updateAlarmById,
};
