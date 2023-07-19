<template>
<div id="app">
   <router-view/>
</div>
</template>

<style>
html,body,
#app{
  width: 100%;
  height: 100%;
}
::-webkit-scrollbar-track
{
  background: rgba(0,0,0,.1);
  border-radius: 0;
}
::-webkit-scrollbar
{
  -webkit-appearance: none;
  width: 10px;
  height: 10px;
}
::-webkit-scrollbar-thumb
{
  cursor:pointer;
  border-radius: 5px;
  background: rgba(0,0,0,.25);
  transition: color .2s ease;
}
</style>
