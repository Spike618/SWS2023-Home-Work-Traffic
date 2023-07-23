<template>
  <el-container class="container-style" style="position: absolute;left: 0;right: 0;top: 0;bottom: 0;overflow: hidden;">
    <el-header class="header" style="background: #545c64">
      <a class="title">User Settings</a>

      <el-menu
          default-active="0"
          mode="horizontal"
          background-color="#545c64"
          text-color="#fff"
          active-text-color="#ffd04b"
          :ellipsis="false"
          @select="headerSelect">

        <el-menu-item v-for="(item,index) in navBar.list" :key="index" :index="index.toString()">{{ item.name }}
        </el-menu-item>
<!--        <el-menu-item>-->
<!--          <template #title>-->
<!--            <el-avatar size="small" src="https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"/>-->
<!--            admin-->
<!--          </template>-->
<!--        </el-menu-item>-->
      </el-menu>

    </el-header>
    <el-container style="height: 100%">
      <el-aside width="200px">
        <el-menu
            background-color="#545c64"
            active-text-color="#ffd04b"
            default-active="0"
            @select="slideSelect"
            style="height: 100%">
          <el-menu-item v-for="(item,index) in slideMenu" :key="index"
                        :index="index.toString()">
            <el-icon>
              <component :is="item.icon"/>
            </el-icon>
            <span>{{ item.name }}</span>
          </el-menu-item>
        </el-menu>


      </el-aside>
      <el-main>
        <component :is="slideMenuComponent"/>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">

import {ref} from "@vue/reactivity";
import InfoEdit from "@/components/InfoEdit.vue";
import router from "@/router";

const quit = () => {
  router.push('/')
}

const navBar = {

  list: [
    {
      name: "Home",
      subActive: '0',
      subMenu: [
        {
          icon: "el-icon-s-home",
          name: "Account Edit",
          component: InfoEdit
        },
      ]
    },

    // {
    //   name: "Account",
    //   subActive: '0',
    //   subMenu: [
    //     {
    //       icon: "",
    //       name: "查询充电站信息",
    //       component: SingleCharge,
    //     },
    //
    //   ]
    // },

  ]
}

const slideMenu = ref<any>(navBar.list[0].subMenu)

const slideMenuActive = ref<any>(navBar.list[0].subActive)

const slideMenuComponent = ref<any>(slideMenu.value[slideMenuActive.value].component)
//顶栏选择
const headerSelect = (key: any, keyPath: any) => {

  //更新左侧导航栏
  console.log(key, keyPath)
  slideMenu.value = navBar.list[key].subMenu
  //更新组件页面
  slideMenuComponent.value = slideMenu.value[slideMenuActive.value].component

}

const slideSelect = (key: string, keyPath: string[]) => {
  //更新组件页面
  slideMenuComponent.value = slideMenu.value[key].component
}
</script>

<style lang="scss" scoped>


::-webkit-scrollbar {
  -webkit-appearance: none;
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-track {
  background-color: rgba(0, 0, 0, .1);
  border-radius: 0;
}

::-webkit-scrollbar-thumb {
  background-color: rgba(0, 0, 0, .25);
  transition: color .2s ease;
  border-radius: 5px;
  cursor: pointer;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.title {
  color: white;
}

.container-style {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;

}


.el-aside {
  border-right: 2px solid #e0dfdb;
  height: 100%;
}
</style>
