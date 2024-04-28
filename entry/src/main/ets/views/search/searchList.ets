import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { http } from '@kit.NetworkKit'
import HomeSubListItemView from '../home/HomeSubListItemView'

@Component
export default struct searchListView{

  @Link keyword:string
  @State listItems:homeSubItemModel[]=[]
  @State loadingFlag:boolean=true
  @Watch("searchReq") @Consume isSearch:boolean
  searchReq(){
    if(this.isSearch===true)
      this.loadingFlag=true
    this.loading()
  }
   aboutToAppear(): void {
    this.loading()
   }

  private async loading() {
    let req = http.createHttp()
    const res = await req.request(`https://api-harmony-teach.itheima.net/hm/question/list?questionBankType=10&keyword=${this.keyword}`)
    let result = (JSON.parse(res.result.toString()) as homeSubListModel).rows
    this.listItems = result
    this.isSearch=false
    this.loadingFlag=false
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
      }.width('100%')
      else{
        Row(){
          Text('加载中。。。')
        }
      }
    }

  }

}