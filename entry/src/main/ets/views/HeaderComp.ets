class AClass{
  a:string='b'
}
let  a:AClass=new AClass()
console.log(`${a.a}`)
@Component
export default struct HeaderComp{

  build() {
Column(){
  TextInput()
}
  }

}