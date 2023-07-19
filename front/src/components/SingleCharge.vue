<template>
  <div class="container" style="width: auto">
    <el-row>
      <el-col :span="12">
        <el-input v-model="SearchVal" placeholder="Please input ChargeId" class="input-with-select"
                  @keyup.enter="enterSearch"  text-align="center" style="margin-left: 50px"  >
          <template #append>
            <el-button :icon="Search" @click="enterSearch"></el-button>
          </template>
        </el-input>
      </el-col>
      <el-col :span="11" >
        <el-button style="margin-left: 70px" size="small" type="primary" @click="AllRest()">AllOn</el-button>
        <el-button size="small" type="danger" @click="AllOff()">AllOff</el-button>
      </el-col>
    </el-row>
    <el-table :data="tableData" style="width: 100%" :header-cell-style="{textAlign: 'center'}" :cell-style="{ textAlign: 'center' }">
      <el-table-column prop="id" label="Charge_Id" width="200px" />
      <el-table-column label="状态" align="center" width="200px">
        <template #default="scope">
          <el-button size="small" type="primary" @click="Rest(scope.row)">On</el-button>
          <el-button size="small" type="danger" @click="Off(scope.row)">Off</el-button>
          <!--el-button size="small" type="primary" @click="Fault(scope.row)">Fault</--el-button-->
        </template>
      </el-table-column>
      <el-table-column label="报表展示" width="200px">
        <template #default="scope">
          <el-button size="small" type="primary" @click="refresh(scope.row)">Report</el-button>
          <!--          <el-button size="small" type="danger" @click="handleDelete(scope.$index,scope.row)">Delete</el-button>-->
        </template>
      </el-table-column>
      <el-table-column label="车辆信息" width="200px">
        <template #default="scope">
          <el-button size="small" type="success" @click="showDetail(scope.row)">Details</el-button>
          <!--          <el-button  size="small" type="danger" @click="handleDelete(scope.$index,scope.row)">Delete</el-button>-->
        </template>
      </el-table-column>
    </el-table>

  </div>
  <detail :is-show="detailShow" :info="info" @close-detail="closeDetail"></detail>
  <report :is-show="reportShow" :info="info" @close-detail="closeReport"></report>
  <!--  <AddVue :is-show="isShow" :info="info" @close-add="closeAdd" @success = "success"></AddVue>-->
</template>

<script lang="ts" setup>
import {Search} from "@element-plus/icons-vue";
import {ref} from "@vue/reactivity";
import UserOrder from "@/class/UserOrder";
import {onMounted } from "vue";
import Detail from "@/components/Detail.vue";
import Report from "@/components/Report.vue";
import {getAllMessage,changeMode} from "@/api/api";
import {ElMessage} from "element-plus";




let dataAll :any
const tableData = ref<any[]>([])

const AllRest =() =>{
  tableData.value = dataAll
  for (let value of dataAll) {
    changeMode("SWITCHON",value["id"])
    console.log("id",value["id"])
  }
    ElMessage({
    message:'所有充电桩打开成功。',
    type:"success"
  })
  tableData.value = dataAll
}
const AllOff =() =>{
  tableData.value = dataAll
  for (let value of dataAll) {
    changeMode("SWITCHOFF",value["id"])
    console.log("id",value["id"])
  }
    ElMessage({
    message:'所有充电桩关闭成功。',
    type:"success"
  })
  tableData.value = dataAll
}
const Rest = (row:any) => {
  console.log("row",row.id)
  ElMessage({
    message:'充电桩打开成功。',
    type:"success"
  })
  changeMode("SWITCHON",row.id)
}
const Off = (row:any) => {
   ElMessage({
     message:'充电桩关闭成功。',
     type:"success"
   })
  changeMode("SWITCHOFF",row.id)

}
// const Fault = (row:any) => {
//   change("FAULT",row.id)
// }
//通过get获取订单信息
const load = async () => {
  const data = {"token": localStorage.getItem("token")}
  dataAll= (await getAllMessage(data))["data"]["charge_array"]
  console.log("dataAll",dataAll)
  tableData.value = dataAll
  console.log("tableData",tableData.value)

}

const SearchVal = ref()
const detailShow = ref(false)
const reportShow = ref(false)
onMounted(async () => {
  await load()
})
const enterSearch = () => {
  let data = []

  if (!SearchVal.value) {
    tableData.value = dataAll

    return
  }
  for (let value of dataAll) {
    if (value["id"].includes(SearchVal.value)) {
      data.push(value)
    }
  }
  tableData.value = data
  console.log("page", tableData.value.length)

}
//子组件向父组件发送信号的执行相应函数
//关闭detail 界面
const closeDetail = () => {
  detailShow.value = false
}
const closeReport = () => {
  reportShow.value = false
}

const info = ref<UserOrder>(new UserOrder())
//
const showDetail = async (row: UserOrder) => {
  const data = {"token": localStorage.getItem("token")}
  const res = await getAllMessage(data)
  dataAll=res.data["charge_array"]
  console.log("dataAll",dataAll)
  detailShow.value = true
  let id = parseInt(row.id)
  info.value = dataAll[id-1]
}
const refresh =async (row:UserOrder) =>{
  const data = {"token": localStorage.getItem("token")}
  const res = await getAllMessage(data)
  dataAll=res.data["charge_array"]
  console.log("dataAll",dataAll)
  reportShow.value = true
  let id = parseInt(row.id)
  info.value = dataAll[id-1]
}


</script>

<style lang="scss" scoped>
.container {
  margin: 100px auto;
  width: 50%;
}

.table {
  margin: 10px 0;
}

.input-with-select {
  width: 100%;
  margin-right: 5px;
}


</style>