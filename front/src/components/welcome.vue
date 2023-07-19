<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="8">
        <div class="grid-content bg-purple">
          <!-- 首页user信息 -->
          <el-card>
            <div class="userCard">
              <el-avatar :size="150" :src=imgUrl></el-avatar>
              <div class="userInfo">
                <p class="important-font">Admin</p>
                <p class="secondary-font">管理员</p>
              </div>
            </div>
            <div class="info-actions">
              <div class="login-info">
                <p>欢迎使用智能充电桩管理系统</p>
              </div>
              <div class="refresh">
                <el-button type="primary" @click="refresh">刷新</el-button>
              </div>
            </div>

          </el-card>
          <!-- 首页表格 -->
          <el-card class="tableInfo">
            <div slot="header">
              <span class="important-font">等候区</span>
            </div>
            <div>
              <el-table
                  :data="tableData"
                  stripe
                  border
                  height="450px"
                  style="width: 100%">
                <el-table-column
                    prop="park-id"
                    label="车位号"
                    width="80">
                </el-table-column>
                <el-table-column
                    prop="user-id"
                    label="用户id"
                    width="80">
                </el-table-column>
                <el-table-column
                    prop="car-id"
                    label="车辆id"
                    width="80">
                </el-table-column>
                <el-table-column
                    prop="mode"
                    label="充电模式">
                </el-table-column>
              </el-table>
            </div>
          </el-card>
        </div>
      </el-col>
      <el-col :span="16">
        <!-- 六个订单信息 -->
        <div class="num">
          <el-card v-for="item in countData" :key="item.name" :body-style="{ display: 'flex',padding: 0 }"
                   class="OrderCard">
            <i class="icon" :class="'el-icon-'+item.icon" :style="{ background: item.color}"></i>
            <div>
              <p class="important-font">￥{{ item.value }}</p>
              <p class="secondary-font">{{ item.name }}</p>
            </div>
          </el-card>

        </div>
        <!-- 柱状图 -->
        <el-card style="height: 280px">
          <div style="height:270px;" ref="barEcharts"></div>
        </el-card>
        <div class="num graph">
          <el-card style="width: 34%;height: 300px;marginRight: 1%">
            <div style="width: 100%;height: 300px;" ref="pieEcharts"></div>
          </el-card>
          <el-card style="width:65%;height: 300px">
            <div style="width: 100%;height: 300px" ref="newEcharts"></div>
          </el-card>
        </div>
      </el-col>
    </el-row>

  </div>
</template>

<script>
import * as echarts from 'echarts';
import {getAllMessage} from "@/api/api";

export default {
  name: "Welcome",
  data() {
    return {
      imgUrl: require('../assets/img/2.svg'),
      value: new Date(),
      tableData: [],
      countData: []
    }
  }, methods: {
    //柱状图
    initBarEcharts(res) {
      // 新建一个promise对象
      let p = new Promise((resolve) => {
        resolve()
      })
      //然后异步执行echarts的初始化函数
      p.then(() => {
        console.log("success")
        //	此dom为echarts图标展示dom
        let myChart = echarts.init(this.$refs.barEcharts)
        let option = {
          title: {
            text: '充电站信息'
          },
          tooltip: {},
          legend: {
            data: ['总充电费用', '总服务费用']
          },
          xAxis: {
            data: ['1号充电桩', '2号充电桩', '3号充电桩', '4号充电桩', '5号充电桩']
          },
          yAxis: {},
          series: [
            {
              name: '总充电费用',
              type: 'bar',
              data: [res.data.charge_array[0].total_charge_fee, res.data.charge_array[1].total_charge_fee, res.data.charge_array[2].total_charge_fee, res.data.charge_array[3].total_charge_fee, res.data.charge_array[4].total_charge_fee]
            },
            {
              name: '总服务费用',
              type: 'bar',
              data: [res.data.charge_array[0].total_charge_service, res.data.charge_array[1].total_charge_service, res.data.charge_array[2].total_charge_service, res.data.charge_array[3].total_charge_service, res.data.charge_array[4].total_charge_service]
            }
          ]
        }
        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
      })
    },
    //饼图
    initPieEcharts(res) {
      let p = new Promise((resolve) => {
        resolve()
      })
      //然后异步执行echarts的初始化函数
      p.then(() => {
        let myChart = echarts.init(this.$refs.pieEcharts);
        let option = {
          tooltip: {
            trigger: 'item'
          },
          legend: {
            top: '0%',
            left: 'left'
          },
          series: [
            {
              name: '充电总量',
              type: 'pie',
              radius: ['20%', '65%'],
              avoidLabelOverlap: false,
              label: {
                show: false,
                position: 'left'
              },
              labelLine: {
                show: false,
              },
              data: [
                {value: res.data.charge_array[0].total_charge, name: '1号充电桩'},
                {value: res.data.charge_array[1].total_charge, name: '2号充电桩'},
                {value: res.data.charge_array[2].total_charge, name: '3号充电桩'},
                {value: res.data.charge_array[3].total_charge, name: '4号充电桩'},
                {value: res.data.charge_array[4].total_charge, name: '5号充电桩'},
              ]
            }
          ]
        }
        myChart.setOption(option);
      })
    },
    initNewEcharts(res) {
      let p = new Promise((resolve) => {
        resolve()
      })

      p.then(() => {
        let myChart = echarts.init(this.$refs.newEcharts);
        let option = {
          title: {
            text: "各充电桩充电时长",
            left: "center"
          },
          tooltip: {},
          legend: {
            data: ['充电时长'],
            left: 0
          },
          xAxis: {
            type: 'category',
            data: ['1号充电桩', '2号充电桩', '3号充电桩', '4号充电桩', '5号充电桩']
          },
          yAxis: {
            type: 'value'
          },
          series: [
            {
              name: "充电时长",
              data: [
                res.data.charge_array[0].total_charge_duration,
                res.data.charge_array[1].total_charge_duration,
                res.data.charge_array[2].total_charge_duration,
                res.data.charge_array[3].total_charge_duration,
                res.data.charge_array[4].total_charge_duration,
              ],
              type: 'bar'
            }
          ]
        }
        myChart.setOption(option)
      })
    },
    initAll() {
      const data = {"token": localStorage.getItem("token")}
      getAllMessage(JSON.stringify(data)).then((res) => {
        console.log("hahaha", res["data"]["wait_array"])
        const transmode = {"F": "快充", "T": "慢充"}
        if (res["code"] == 0) {
          let i = 0
          if (res["data"]["wait_array"] != null) {
            for (let wait_item of res["data"]["wait_array"]) {
              let temp_data = {
                'park-id': (i + 1) + "号车位",
                'user-id': "user-" + wait_item.user_id,
                'car-id': "car-" + wait_item.car_id,
                'mode': transmode[wait_item.mode]
              }
              this.tableData.push(temp_data)
              i = i + 1
            }
          }

          let f_price = 0
          var date_now = new Date()
          var hour = date_now.getHours()
          if (hour < 7) {
            f_price = 0.4
          } else if (hour < 10) {
            f_price = 0.7
          } else if (hour < 15) {
            f_price = 1.0
          } else if (hour < 18) {
            f_price = 0.7
          } else if (hour < 21) {
            f_price = 1.0
          } else if (hour < 23) {
            f_price = 0.7
          } else {
            f_price = 0.4
          }
          let temp_data = {
            name: '当前快充电价',
            value: f_price + "元/度",
            icon: 'success',
            color: '#2ec7c9'
          }
          this.countData.push(temp_data)
          temp_data = {
            name: '当前慢充电价',
            value: f_price + "元/度",
            icon: 'star-on',
            color: '#ffb980'
          }
          this.countData.push(temp_data)
          this.initBarEcharts(res)
          this.initPieEcharts(res)
          this.initNewEcharts(res)
        }
      })
    },
    refresh() {
      this.countData = []
      this.tableData = []
      this.initAll()
    }
  },
  mounted() {
    this.initAll()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="less" scoped>
.el-card__body {
  padding: 10px;
}

.userCard {
  height: 180px;
  display: flex;
  border-bottom: 2px solid #DCDFE6;
  border-radius: 2px;
}

.userInfo {
  width: auto;
  padding: 6% 0 0 6%;
}

.important-font {
  font-weight: 700;
  font-size: 20px;
}

.secondary-font {
  color: #909399;
}

.login-info {
  height: 40px;
  text-align: left;
  color: #909399;
  margin-right: 10px;
}

.tableInfo {
  margin: 20px 0 0 0;

}

.OrderCard {
  margin: 0 0 30px 30px;
  border: #DCDFE6 1px solid;
  border-radius: 10px;
  height: 100px;
  width: 200px;

  i {
    width: 30%;
    line-height: 80px;
    font-size: 30px;
    color: #fff
  }

  div {
    width: 100px;
  }
}

.el-card {
  border: none;
}

.num {
  display: flex;
  flex-wrap: wrap;
  height: auto;
}

.graph {
  margin: 15px 0 0 0;
}

.el-calendar {
  height: 265px;
}

.refresh {
  padding-top: 10px;
  padding-left: 10px;
  border-radius: 5px;
  height: 40px;
}

.info-actions {
  display: flex;
  margin-left: auto; /* 将子元素靠右对齐 */
}
</style>