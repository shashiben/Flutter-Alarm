import mongoose from "mongoose";

const alarmSchema = mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  timeStamp: {
    type: Number,
    required: true,
  },
  alarmTime: {
    type: Number,
    required: true,
  },
});
const AlarmModel = mongoose.model("AlarmModel", alarmSchema);

export default AlarmModel;
