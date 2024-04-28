import { http } from '@kit.NetworkKit';
import { allResponse, tracking } from './myReq';
import { promptAction } from '@kit.ArkUI';

export interface iTimeList {
  /**
   * 结束时间（毫秒）
   */
  endTime: number;

  /**
   * 试题id
   */
  questionId: string;

  /**
   * 开始时间(毫秒)
   */
  startTime: number;
}


class TrackingService {
  // 类的实例属性
  timelist: iTimeList = {
    questionId: "0",
    endTime: 0,
    startTime: 0
  }

  // 初始化-重置数据
  constructor() {
    this.timelist = {
      questionId: "0",
      endTime: 0,
      startTime: 0
    }
  }

  //  1. 收集用户进入页面的时间
  setStartTime() {
    this.timelist.startTime = Date.now()
  }

  //  2. 收集用户离开页面的时间
  setEndTime() {
    this.timelist.endTime = Date.now()
  }

  // 3. 设置用户阅读的题目id
  setQuestionId(questid: string) {
    this.timelist.questionId = questid
  }

  // 4. 把收集好的数据请求服务器接口提交时长数据
  async save() {

    let req=http.createHttp()

    const res=await tracking()

    const result=JSON.parse(res.result.toString()) as allResponse<string>

    console.log(`studyTimeSave:${result.message}`)

    if(result.success===true)
    promptAction.showToast({message:`study time save success`})

  }
}

// 导出类的实例化对象
export const trackingService = new TrackingService()