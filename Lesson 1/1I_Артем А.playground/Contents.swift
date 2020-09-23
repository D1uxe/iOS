import UIKit

// 1. Решить квадратное уравнение x^2-2x-3=0
let a: Double = 1
let b: Double = -2
let c: Double = -3
let D: Double = pow(b,2) - 4*a * c
var roots: (x1: Double,x2: Double) = (0.0,0.0)

switch D {
case let d where d>0:
    roots = ((-b+sqrt(d))/2*a, (-b-sqrt(d))/2*a)
    print("Уравнение имеет два корня х1= \(roots.x1) х2 = \(roots.x2)")
 
case let d where d==0:
    roots.x1 = (-b+sqrt(d))/2*a
    print("Уравнение имеет один корень. х1 = \(roots.x1)")
    
default:
        print("Дискриминант отрицательный D= \(D). Корней нет")

}






// 2. Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника

let cathetus1: Float = 5.4
let cathetus2: Float = 2.1
let hypotenus: Float = sqrtf(powf(cathetus1, 2) + powf(cathetus2, 2))
let Square: Float = (cathetus1 * cathetus2)*0.5
let Perimetr: Float = cathetus1 + cathetus2 + hypotenus

print(String(format: "Гипотенуза треугольника: %.2f",hypotenus))
print(String(format: "Площадь треугольника: %.2f",Square))
print(String(format: "Периметр треугольника: %.2f",Perimetr))






// 3. Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.

let deposit: Double = 10_000
let percent: Double = 10
let duration: Int = 5
var result = deposit * pow(1 + percent*0.01, Double(duration))
print(String(format: "Депозит: \(deposit). Сумма на счете под \(percent)%% годовых через \(duration) лет : %.2f",result))



// через рекурсию
func totalReturnOn(investment deposit: Double, interestRate percent: Double, duration years: Int) -> Double
{
    if years==0
    {
        return deposit
    }
 return  totalReturnOn(investment: deposit + deposit * percent*0.01, interestRate: percent, duration: years-1)
    
}

print("\n[Рекурсия] Депозит: \(deposit). Сумма на счете под \(percent)% годовых через \(duration) лет: \(totalReturnOn(investment: deposit, interestRate: percent, duration: duration))")


//через циклы

var result2: Double = deposit
for _ in 0..<duration {
    
    result2 += result2*percent*0.01
}
print ("[Цикл] Депозит: \(deposit). Сумма на счете под \(percent)% годовых через \(duration) лет: \(result2)")
