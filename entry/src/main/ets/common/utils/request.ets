
import { HdResponse } from '../../models/HttpResponseModel'
import http from '@ohos.net.http'
import { authStore } from './Auth'
import { promptAction, router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'

type HdParams = Record<string, number | string | boolean>

class HdHttp {
  private baseUrl: string

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl || ''
  }

  get<T>(url: string, extraData?: Object): Promise<HdResponse<T>> {
    const httpInstance = http.createHttp()
    url = this.baseUrl + url

    if (extraData) {
      const paramsList = Object.keys(extraData).map(key => `${key}=${(extraData as HdParams)[key]}`)
      const paramsString = paramsList.join('&')
      console.log(
        paramsString)
      url += '?' + paramsString
    }

    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      }
    , expectDataType: http.HttpDataType.OBJECT
    }

    const currentUser = authStore.getUser()

    if (currentUser.token && options.header) {
      options.header['Authorization'] = `Bearer ${currentUser.token}`
    }

    return httpInstance.request(url, options).then(res => {
      if (res.result) {
        const result = res.result as HdResponse<T>
        if (result.code === 401) {
          promptAction.showToast({ message: 'token失效' })
          authStore.delUser()
          router.pushUrl({
            url: 'pages/LoginPage'
          }, router.RouterMode.Single)
        }
        return result
      }
      return Promise.reject(res.result)
    })
      .catch((err: BusinessError) => {
        promptAction.showToast({ message: err.message || '网络错误' })
        return Promise.reject(err)
      })
  }

  post<T>(url: string, extraData?: Object): Promise<HdResponse<T>> {
    const httpInstance = http.createHttp()

    url = this.baseUrl + url

    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json'
      }
    , expectDataType: http.HttpDataType.OBJECT
    }

    if (extraData) {
      options.extraData = extraData
    }

    const currentUser = authStore.getUser()

    if (currentUser.token && options.header) {
      options.header['Authorization'] = `Bear ${currentUser.token}}`
    }

    return httpInstance.request(url, options).then(res => {
      if (res.result) {
        const result = res.result as HdResponse<T>
        if (result.code === 401) {
          authStore.delUser()
          router.pushUrl({
            url: 'pages/LoginPage'
          }, router.RouterMode.Single)
        }
        return result
      }
      return Promise.reject(res.responseCode)
    }).catch((err: BusinessError) => {
      promptAction.showToast({ message: err.message || '网络错误' })
      return Promise.reject(err)
    })
  }
}

export const hdHttp = new HdHttp('https://api-harmony-teach.itheima.net/hm/')