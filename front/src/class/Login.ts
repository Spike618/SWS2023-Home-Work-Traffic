import {ref} from "vue";

export interface User{
    username: string,
    password: string,
}//类型匹配
interface rules{
    username: ({
        required: boolean;
        message: string;
        trigger: string;
        min?: undefined;
    } | {
        required: boolean;
        message: string;
        min: number;
        trigger: string;
    })[];
    password: ({
        required: boolean;
        message: string;
        trigger: string;
        min?: undefined;
    } | {
        required: boolean;
        message: string;
        min: number;
        trigger: string;
    })[];
}
export const loginUser = ref<User>({
    username: "",
    password: "",
})
export const rules = ref<rules>({
    username: [
        {required: true, message: "请输入用户名", trigger: 'blur'},
        {required: true, message: "用户名长度应大于五位", min: 0, trigger: 'blur'},
    ],
    password: [
        {required: true, message: "请输入密码", trigger: 'blur'},
        {required: true, message: "密码至少为6位", min: 0, trigger: 'blur'},
    ],
});
