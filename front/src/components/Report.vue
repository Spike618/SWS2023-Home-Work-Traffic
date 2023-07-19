<template>
  <el-dialog v-model="dialogVisible" width="80%" @close="$emit('closeDetail')" draggable>
    <el-descriptions title="用户订单详情" direction="horizontal" column=4 border>
      <el-descriptions-item label="充电桩ID">{{ info.id }}</el-descriptions-item>
      <el-descriptions-item label="名字">{{ info.name }}</el-descriptions-item>
      <el-descriptions-item label="充电模式">{{ info.mode }}</el-descriptions-item>
      <el-descriptions-item label="充电价格">{{ info.price }}</el-descriptions-item>
      <el-descriptions-item label="工作状态">{{ info.state}}</el-descriptions-item>
      <el-descriptions-item label="总充电总量">{{ info.total_charge}}</el-descriptions-item>
      <el-descriptions-item label="总充电次数">{{ info.total_charge_times}}</el-descriptions-item>
      <el-descriptions-item label="总充电时长">{{ info.total_charge_duration}}</el-descriptions-item>
      <el-descriptions-item label="总充电费用">{{ info.total_charge_fee }}</el-descriptions-item>
      <el-descriptions-item label="总服务费用">{{ info.total_charge_service }}</el-descriptions-item>
      <el-descriptions-item label="总费用">{{ info.total_fee}}</el-descriptions-item>
    </el-descriptions>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="closeReport">确认</el-button>
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
  info: UserOrder
})
//控制显示绑定,监听,设置界面是否显示
const dialogVisible = computed(() => props.isShow)

//定义向父组件发送的信号关闭信号
const emits = defineEmits(["closeDetail"])


const size = ref('')
const blockMargin = computed(() => {
  const marginMap:any = {
    large: '32px',
    default: '28px',
    small: '24px',
  }
  return {
    marginTop: marginMap[size.value] || marginMap.default,
  }
})

//关闭界面信号发送
const closeReport=()=>{
  emits("closeDetail")
}

</script>

<style scoped>

</style>