import { preferences } from '@kit.ArkData'


export interface ProfileUser{
  success: boolean;
  code: number;
  message: string;
  data: string;
}

export interface InfoUser {
  nickName: string;
  avatar: string;
  flag: boolean;
  clockinNumbers: number;
  clockinTotal: number;
  id: string;
  questionNumber: number;
  totalTime: number;
}
export interface HdUser {
  //用户头像地址
  avatar: string;

  //连续打卡天数
  clockinNumbers?: number;

  //用户id
  id: string;

  //昵称
  nickName?: string;

  //token过期后，刷新token使用
  refreshToken: string;

  //后续交互使用的token
  token: string;

  //学习时长，单位s
  totalTime?: number;

  //昵称
  username: string;
}

// 登录成功后，获取到的用户数据结构
export class HdUserModel implements HdUser {
  id: string = ''
  username: string = ''
  avatar: string = ''
  token: string = ''
  refreshToken: string = ''
  nickName?: string = ''
  totalTime?: number = 0
  clockinNumbers?: number = 0

  constructor(model: HdUser) {
    this.id = model.id
    this.username = model.username
    this.avatar = model.avatar
    this.token = model.token
    this.refreshToken = model.refreshToken
    this.nickName = model.nickName
    this.totalTime = model.totalTime
    this.clockinNumbers = model.clockinNumbers
  }
}

// 用户信息操作类
class AuthStore {
  KEY = 'authStore'
  // store = preferences.getPreferencesSync(getContext(), { name: this.KEY })

  async setUser(user: HdUser) {
    AppStorage.setOrCreate(this.KEY, user)
    // await this.store.put(this.KEY, JSON.stringify(user))
    // await this.store.flush()
  }

  async delUser() {
    AppStorage.setOrCreate(this.KEY, {})
    // await this.store.put(this.KEY, '{}')
    // await this.store.flush()
  }

  getUser() {
    return AppStorage.get<HdUser>(this.KEY) || {} as HdUser
  }
}

// 导出
export const authStore = new AuthStore()