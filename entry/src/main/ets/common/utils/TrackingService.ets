import { http } from '@kit.NetworkKit';
import { allResponse, tracking } from './myReq';
import { promptAction } from '@kit.ArkUI';
import { HdHttp } from './request';
import { userAuth } from '@kit.UserAuthenticationKit';
import { authStore } from './Auth';


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
    let user=authStore.getUser()
    let req=http.createHttp()
    let token=user.token
    const res =await req.request('https://api-harmony-teach.itheima.net/hm/time/tracking',{
      method:http.RequestMethod.POST,
      header:{
        contentType: 'application/json',
        Authorization:`Bearer ${token}`,
      },
      extraData:{timeList:[this.timelist]}
    })
    const result=(res.result as allResponse<string>).success
    if(result){
      console.log('tracking success')
    }else {
      console.log(`res is:${JSON.stringify(res.result)}`)
      console.log('tracking failed')
    }
  }
}

// 导出类的实例化对象
export const trackingService = new TrackingService()