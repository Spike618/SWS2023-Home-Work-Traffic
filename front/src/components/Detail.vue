<template>
  <el-dialog v-model="dialogVisible" width="80%" @close="$emit('closeDetail')" draggable>
    <el-descriptions title="充电桩服务车辆详情" direction="horizontal" column=4 border
    v-for="(item,index) in info?.car_blocks" :key="index" :index="index.toString()">
      <el-descriptions-item label="车位的车辆分配的number">{{ item["number"] }}</el-descriptions-item>
      <el-descriptions-item label="车辆ID">{{ item["car_id"] }}</el-descriptions-item>
      <el-descriptions-item label="用户ID">{{  item["user_id"] }}</el-descriptions-item>
      <el-descriptions-item label="名字">{{  item["name"]}}</el-descriptions-item>
      <el-descriptions-item label="总电量">{{  item["power_capacity"] }}</el-descriptions-item>
      <el-descriptions-item label="当前电量">{{  item["power_current"] }}</el-descriptions-item>
      <el-descriptions-item label="申请的充电量">{{  item["apply_kwh"] }}</el-descriptions-item>
      <el-descriptions-item label="等待时间">{{ item["wait_time"] }}</el-descriptions-item>
      <el-descriptions-item label="车位内的充电状态">{{  item["state"] }}</el-descriptions-item>
    </el-descriptions>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="closeDetail">确认</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import {computed, ref} from 'vue'
import UserOrder from "@/class/UserOrder";

//内置函数用于接受父组件参数
const props = defineProps({
  isShow: Boolean,
  info: UserOrder,
})
//控制显示绑定,监听,设置界面是否显示
const dialogVisible = computed(() => props.isShow)

//定义向父组件发送的信号关闭信号
const emits = defineEmits(["closeDetail"])


const size = ref('')
const blockMargin = computed(() => {
  const marginMap :any= {
    large: '32px',
    default: '28px',
    small: '24px',
  }
  return {
    marginTop: marginMap[size.value] || marginMap.default,
  }
})

//关闭界面信号发送
const closeDetail=()=>{
  emits("closeDetail")
}

</script>

<style scoped>

</style>
