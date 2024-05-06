import { http } from '@kit.NetworkKit';
import axios, { AxiosResponse } from '@ohos/axios';
import { homeSubItemModel, homeSubListModel, subListQuery } from '../../models/homeSubListModel';
import { questionDetail } from '../../models/questionDetailModel';
import { authStore } from './Auth';
let req=http.createHttp()
let user=authStore.getUser()
let token=user.token
export interface allResponse<T>{
  success:boolean
  code:number
  message:string
  data:T
}
let baseUrl='https://api-harmony-teach.itheima.net/hm/'
export interface userData{
  token:string
  id:string
  username:string
  avator:string
  nickName:string
  totalTime:number
  shareInfo:string
  clockinNumber:number
}



interface hasClock{
  flag:boolean
}

export const  login=()=>{
  req.request(`${baseUrl}login`,
    {
      method: http.RequestMethod.POST,
      header: {
        contentType: 'application/json'
      },
      extraData: {
        "username": "hmheima",
        "password": "Hmheima%123"
      }
    })
    .then(res => {
      let result=(JSON.parse(res.result.toString()) as allResponse<userData>)
      token=result.data.token
      console.log(`token:${token}`)
    })
    .catch((err: Error) => {
      console.log(`err:${err}`);
    });
}

export const hasCLockIn=()=>{
  req.request(`${baseUrl}hasClockIn`,
    {
      method:http.RequestMethod.GET,
      header:{
        contentType: 'application/json',
        Authorization:`Bearer ${token}`
      }
    }
  ).then((res)=>{
    console.info(`start hasClockIn`)
    let result=(JSON.parse(res.result.toString()) as allResponse<hasClock>)
    console.log(`hasClockInt: ${JSON.stringify(result.data)}`)
    console.info('end hasClockIn')
  })
}

export const getHomeTypeList=()=>{

  req.request(`https://api-harmony-teach.itheima.net/hm/question/type?type=items`,
    {
      method:http.RequestMethod.GET,
      header:{
        Authorization:`Bearer ${token}`,
      }
    }
  ).then((res)=>{
    console.info(`start type`)
    // let result:allResponse<homeSubListModel>={} as allResponse<homeSubListModel>
    console.log(`subType:${JSON.stringify(res)}`)
    if(res!=undefined){
      console.log(`type:${JSON.stringify(res.result)}`)
    }
    else{
      console.log('type undefined')
    }
    // console.log(`sub list:${JSON.stringify(result)}`)
    console.info('end type')

  })

}

export const getHomeSubList=  (questionType:number,typeId:number,page?:number,sort?:number)=>{

  return  req.request(`https://api-harmony-teach.itheima.net/hm/question/list?questionBankType=${questionType}&type=${typeId}&page=${page}&sort=${sort}`)

}

export const checkBack=()=>{
  req.request('https://api-harmony-teach.itheima.net/hm/question/feedback/type',
    {
      method:http.RequestMethod.GET,
      header:{
        Authorization:`Bearer ${token}`,
      }
    }
  ).then(res=>{
    console.info(`feelback:${JSON.stringify(res.result)}`)
  })
}

export const getQuestionDetail=  (id?:string):questionDetail=>{

    let obj:questionDetail={} as questionDetail

   axios.get<questionDetail,AxiosResponse<questionDetail>,null>(`https://api-harmony-teach.itheima.net/hm/question/${id}`, { headers:{ Authorization:`Bearer ${token}`, } })
     .then((res:AxiosResponse)=>{
       console.log(`data:${JSON.stringify(res.data.data)}`)
        obj=res.data.data
     })
  return obj
}

export const getLikeOrCollect=(id:string,optType:number)=>{

  return req.request('https://api-harmony-teach.itheima.net/hm/question/opt',{
    method:http.RequestMethod.POST,
    header:{
      contentType: 'application/json',
      Authorization:`Bearer ${token}`,
    },
    extraData:{
      id:id,
      optType:optType
    }
  })
}

export const getClockIn=()=>{
  return req.request('https://api-harmony-teach.itheima.net/hm/clockin',{
    method:http.RequestMethod.POST,
    header:{
      contentType: 'application/json',
      Authorization:`Bearer ${token}`,
    }
  })
}

export const getClockInDays=()=>{

  return req.request('https://api-harmony-teach.itheima.net/hm/clockinInfo',{
    header:{
      Authorization:`Bearer ${token}`
    }
  })

}

export const getUserInfo=()=>{
  return req.request('https://api-harmony-teach.itheima.net/hm/userInfo',{
    method:http.RequestMethod.POST,
    header:{
      contentType: 'application/json',
      Authorization:`Bearer ${token}`,
    }
  })
}

export const updateUserAvatarNickName=(avatar:string,nickName?:string)=>{
  return req.request('https://api-harmony-teach.itheima.net/hm/userInfo/profile',{
    method:http.RequestMethod.POST,
    header:{
      contentType: 'application/json',
      Authorization:`Bearer ${token}`,
    },
    extraData:{
      avatar:avatar,
      nickName:nickName
    }
  })
}

export const studyInfo=()=>{
  return req.request('https://api-harmony-teach.itheima.net/hm/studyInfo',{
    method:http.RequestMethod.GET,
    header:{
      Authorization:`Bearer ${token}`,
    }
  })
}

export const tracking=()=>{
  return req.request('https://api-harmony-teach.itheima.net/hm/time/tracking',{
    method:http.RequestMethod.POST,
    header:{
      contentType: 'application/json',
      Authorization:`Bearer ${token}`,
    }
  })
}

export const getQuestionType=()=>{
  return req.request('https://api-harmony-teach.itheima.net/hm/question/type?type=items')
}

export const getQuestionList=(id:number,sort?:number)=>{
  if(sort===undefined)
    return req.request(`https://api-harmony-teach.itheima.net/hm/question/list?id=${id}&questionBankType=10`)
  else
    return req.request(`https://api-harmony-teach.itheima.net/hm/question/list?id=${id}&questionBankType=10&sort=${sort}`)

}
