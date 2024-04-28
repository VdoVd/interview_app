import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { http } from '@kit.NetworkKit'
import HomeSubListItemView from '../home/HomeSubListItemView'
import { allResponse } from '../../common/utils/myReq'

@Component
export default struct searchListView{

  @Consume keyword:string
  @State listItems:homeSubItemModel[]=[]
  @State loadingFlag:boolean=true
  @Consume @Watch("searchReq")  isSearch:boolean
  searchReq(){
    if(this.isSearch===true) {
      this.loadingFlag = true
      this.loading()
    }
  }
  private async loading() {
    console.log('start loading...')
    let req = http.createHttp()
    const res = await req.request(`https://api-harmony-teach.itheima.net/hm/question/list?questionBankType=10&keyword=vue`)
    let result = (JSON.parse(res.result.toString()) as allResponse<homeSubListModel>).data.rows
    console.log(`result:${JSON.stringify(result)}`)
    this.listItems = result
    this.isSearch=false
    this.loadingFlag=false
    this.keyword=''
    console.log('end loading...')
  }
  build() {
    Column(){
      if(this.loadingFlag===false)
      List(){
        ForEach(this.listItems,(item:homeSubItemModel,index:number)=>{
          ListItem(){
            HomeSubListItemView({item:item})
          }
        })
        ListItem(){
          Text('加载成功')
        }
      }.width('100%').padding(20)
      else{
        Row(){
          Text('加载中。。。')
        }
      }
    }
  }
}