import searchListView from '../views/search/searchList'

PersistentStorage.persistProp<string[]>('searchRecord',[])
@Entry
@Component
struct searchPage{
  @StorageLink('searchRecord') arr:string[]=[]
  @State searchText:string=''
  @State delete:boolean=false
  @Provide isSearch:boolean=false
  build() {
    Navigation(){
      Column({space:16}){
        Column({space:10}){
          Row({space:10}){
            TextInput({placeholder:'请输入关键字',text:$$this.searchText})
              .onSubmit(()=>{
                this.arr.push(this.searchText)
                this.searchText=''
                this.isSearch=true
              })
              .layoutWeight(1)
            if(this.searchText!='')
              Text('取消').fontColor(Color.Gray).onClick(()=>{this.searchText=''})
          }
          Row(){
            Text('搜索记录').layoutWeight(1).fontWeight(FontWeight.Bold).textAlign(TextAlign.Start).width('93%')
            if(this.delete===false)
              Image($r('app.media.ic_common_delete'))
                .width(20)
                .onClick(()=>{
                  this.delete=true
                })
            else{
              Row({space:10}){
                Text('全部删除').fontColor(Color.Gray).fontSize(13).onClick(()=>{
                  this.arr=[...[]]
                  this.delete=false
                })
                Text('|').fontSize(13).fontColor(Color.Gray)
                Text('完成').fontColor(Color.Gray).fontSize(13).onClick(()=>{
                  this.delete=false
                })
              }
            }
          }.width('90%')
          Flex({wrap:FlexWrap.Wrap}){
            ForEach(this.arr,(item:string,index:number)=>{
              this.flexTextBuilder(item)
            })
          }.width('93%')
        }

        searchListView({keyword:this.searchText})

      }
    }.title('刷个面试题')
    .titleMode(NavigationTitleMode.Mini)
  }
  @Builder
  flexTextBuilder(text:string) {
    Text(text)
      .fontColor(Color.Gray)
      .backgroundColor('rgba(0,0,0,0.1)')
      .padding(6)
      .borderRadius(13)
      .margin(9)
  }
}