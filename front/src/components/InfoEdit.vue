<template>
  <div class="user-info-edit">
    <h2>Edit User Information</h2>
    <el-form :model="userInfo" :rules="rules" ref="userInfoForm" label-width="100px">
      <el-form-item label="Username" prop="username">
        <el-input v-model="userInfo.username"></el-input>
      </el-form-item>
      <el-form-item label="Email" prop="email">
        <el-input v-model="userInfo.email"></el-input>
      </el-form-item>
      <el-form-item label="Password" prop="password">
        <el-input type="password" v-model="userInfo.password"></el-input>
      </el-form-item>
      <el-form-item label="Home" prop="home">
        <el-input v-model="userInfo.home"></el-input>
      </el-form-item>
      <el-form-item label="Company" prop="company">
        <el-input v-model="userInfo.company"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="saveUserInfo">Save</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userInfo: {
        username: '',
        email: '',
        password: '',
        // Home: '',
        // Company: '',
      },
      rules: {
        username: [
          {required: true, message: 'Please enter your username', trigger: 'blur'}
        ],
        email: [
          {required: true, message: 'Please enter your email', trigger: 'blur'},
          {type: 'email', message: 'Please enter a valid email address', trigger: ['blur', 'change']}
        ],
        password: [
          {required: true, message: 'Please enter your password', trigger: 'blur'}
        ],
        home: [
          {required: true, message: 'Edit your home address', trigger: 'blur'}
        ],
        company: [
          {required: true, message: 'Edit your company address', trigger: 'blur'}
        ]
      }
    };
  },
  methods: {
    saveUserInfo() {
      this.$refs.userInfoForm.validate((valid) => {
        if (valid) {
          // Perform API call to save user information
          // Replace the following line with your actual API call
          console.log('Saving user information:', this.userInfo);
        } else {
          this.$message.error('Please fill in all required fields.');
        }
      });
    }
  }
};
</script>

<style>
.user-info-edit {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
}
</style>
