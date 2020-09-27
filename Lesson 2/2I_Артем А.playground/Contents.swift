import Foundation

// 1. Написать функцию, которая определяет, четное число или нет.
// 2. Написать функцию, которая определяет, делится ли число без остатка на 3.

let num: Int = 3
var result: String = ""

func check(number: Int, predicate: (Int) -> Bool) -> Bool {
    return predicate(number)
}

// Четное число
result = check(number: num, predicate: { $0 % 2 == 0 }) ? "Четное" : "Нечетное"
result

// Число делится на 3
result = check(number: num, predicate: { $0 % 3 == 0 }) ? "Делится на 3" : "Не делится на 3"
result




// 3. Создать возрастающий массив из 100 чисел.

var sourceAarray: [Int] = Array(1 ... 100)




// 4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.

func clear(array: inout [Int]) {
    for item in array {
        if check(number: item, predicate: { $0 % 2 == 0 }) || !check(number: item, predicate: { $0 % 3 == 0 }) {
            array.remove(at: array.firstIndex(of: item)!)
        }
    }
}

clear(array: &sourceAarray)

// изящный способ :)
var sourceAarray2: [Int] = Array(1 ... 100)
sourceAarray2.removeAll(where: { $0 % 2 == 0 || $0 % 3 != 0 })
// sourceAarray2.removeAll(where: { (r) -> Bool in r % 2 == 0 || r % 3 != 0 })
sourceAarray2




// 5.* Написать функцию, которая добавляет в массив новое число Фибоначчи, и добавить при помощи нее 100 элементов.
// Числа Фибоначчи определяются соотношениями Fn=Fn-1 + Fn-2.



// В тип double 100 чисел Фибоначчи помещается, но выглядит не очень красиво.
// Написал свой тип, где числа хранятся в виде строк. А складываем методом "в столбик"

struct BigInt {
    var value: String = ""

    init(_ value: Int) {
        self.value = String(value)
    }

    init(_ value: String) {
        self.value = value
    }
}

extension BigInt {
    // сложение в столбик
    static func + (left: BigInt, right: BigInt) -> BigInt {
        let firstNumber: [Int] = Array(left.value).map({ Int(String($0)) ?? 0 }).reversed()
        let secondNumber: [Int] = Array(right.value).map({ Int(String($0)) ?? 0 }).reversed()

        var carryDigit = 0 // перенос в следующий разряд
        var result = [Int]()

        for i in 0 ..< max(firstNumber.count, secondNumber.count) {
            // если разряда нет, то возьмем ноль, иначе берем первый разряд числа
            let digitFirstNum = i > firstNumber.count - 1 ? 0 : firstNumber[i]
            let digitSecondNum = i > secondNumber.count - 1 ? 0 : secondNumber[i]
            
            // складываем два числа и разряд с прошлой итерации
            var sum = digitFirstNum + digitSecondNum + carryDigit
            
            if sum > 9 {
                sum -= 10
                carryDigit = 1
            }
            else {
                carryDigit = 0
            }
            
            result.insert(sum, at: 0)
        }

        if carryDigit != 0 {
            result.insert(carryDigit, at: 0) // при 999+1 нужно добавить разряд к результату
        }

        return BigInt(result.map({ String($0) }).joined())
    }
}

func generateFiboNumbers(count n: Int) -> [BigInt] {
    var fiboNumbers: [BigInt] = [BigInt(1), BigInt(1)]

    for i in 2 ..< n {
        fiboNumbers.append(fiboNumbers[i - 1] + fiboNumbers[i - 2])
    }

    return fiboNumbers
}

generateFiboNumbers(count: 100)




/*
 6. * Заполнить массив из 100 элементов различными простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n, следуя методу Эратосфена, нужно выполнить следующие шаги:

 a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
 b. Пусть переменная p изначально равна двум — первому простому числу.
 c. Зачеркнуть в списке числа от 2p до n, считая шагом p..
 d. Найти первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
 e. Повторять шаги c и d, пока возможно.
 */

func generatePrimeNumbersByErastofen(count n: Int) -> Array<Int> {
    var primeNumbers = Array<Int>(0 ... n)

    for p in 2 ..< primeNumbers.count {
        if primeNumbers[p] != 0 {
            for i in stride(from: p * p, to: primeNumbers.count, by: p) {
                primeNumbers[i] = 0
            }
        }
    }
    primeNumbers.removeAll(where: { $0 == 0 || $0 == 1 })
    return primeNumbers
    
    // return primeNumbers.removeAll(where: {$0 == 0}) // Почему нельзя сдлать это в одну строку? Надо как-то по-другому? Говорит не может преобразовать ()->Array<int>
}

generatePrimeNumbersByErastofen(count: 100)
