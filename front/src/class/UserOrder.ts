
export default class UserOrder {
    id: string=""
    name: string=""
    mode: string=""
    price: number=0
    state: string=""
    total_charge: number=0
    total_charge_times: number=0
    total_charge_duration: number=0
    total_charge_fee:number=0
    total_charge_service:number=0
    total_fee:number=0
    car_blocks:object[]= [
        {
            number: "",
            user_id: "",
            name: "",
            power_capacity: 0,
            power_current: 0,
            apply_kwh: 0,
            wait_time: 0,
            state: "",
        }
    ]
}
