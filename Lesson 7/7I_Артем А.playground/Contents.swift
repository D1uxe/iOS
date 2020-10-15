import Foundation

/*                           Урок 7. Обработка ошибок и исключений
 Придумать класс, методы которого могут завершаться неудачей и возвращать либо значение, либо ошибку Error?. Реализовать их вызов и обработать результат метода при помощи конструкции if let, или guard let.
 Придумать класс, методы которого могут выбрасывать ошибки. Реализуйте несколько throws-функций. Вызовите их и обработайте результат вызова при помощи конструкции try/catch.

 */

// Банкомат
enum CashMachineError: String, Error {
    case invalidPinCode = "Неверный пин код"
    case isFull = "Банкомат полон и не принимает наличные"
    case isEmpty = "В банкомате нед денег"
    case notEnoughMoney = "На счете не достаточно денег"

    enum CardError: Error {
        case invalidCard
        case cantReadCard
    }
}

struct Card {
    var holderName: String = ""
    var number: String = ""
    var expirationDate: String = ""
    var amountOfMoney: Int = 0
    let pinCode: Int = 1111
}

enum Currency {
    case rub(amount: Int)
    case eur(amount: Int)
}

class CashMachine {
    
    // MARK: - Private Properties

    private var rubCassette: Int = 10000
    private var eurCassette: Int = 5000
    private var card: Card = Card()

    
    // MARK: - Public Methods

    func insertCard(card: Card) -> Result<String, CashMachineError.CardError> {
        // закончился срок действия карты
        guard card.expirationDate != "" else {
            return .failure(.invalidCard)
        }
        // что-то с номером карты или именем
        guard card.number != "" && card.holderName != "" else {
            return .failure(.cantReadCard)
        }
        // все ок, карта принята
        self.card = card
        return .success("Карта принята. Введите пин код")
    }

    
    // внесение наличных
    func depositCash(currency: Currency, pinCode: Int) -> (response: String?, error: CashMachineError?) {
        // неверный пин код
        guard card.pinCode == pinCode else {
            return (nil, .invalidPinCode)
        }

        switch currency {
        case let .rub(amount: rubAmount):
            guard rubAmount + rubCassette <= 11000 else { // вносимая сумма меньше, чем вмещается в кассету банкомата
                return (nil, .isFull)
            }
            rubCassette += rubAmount
            return ("Сумма \(rubAmount) рублей внесена. Заберите вашу карту", nil)

        case let .eur(amount: eurAmount):
            guard eurAmount + eurCassette <= 5500 else { // вносимая сумма меньше, чем вмещается в кассету банкомата
                return (nil, .isFull)
            }
            eurCassette += eurAmount
            return ("Сумма \(eurAmount) евро внесена. Заберите вашу карту", nil)
        }
    }

    
    // снятие наличных
    func wihdrawCash(currency: Currency, pinCode: Int) throws -> Int {
        // неверный пин код
        guard card.pinCode == pinCode else {
            throw CashMachineError.invalidPinCode
        }

        switch currency {
        case let .rub(amount: rubAmount):
            guard rubAmount <= rubCassette else { // запрошенная сумма больше, чем есть в банкомате
                throw CashMachineError.isEmpty
            }
            guard rubAmount <= card.amountOfMoney else { // запрошенная сумма больше, чем есть на счете
                throw CashMachineError.notEnoughMoney
            }
            // банкомат и счет стали "полегче"
            rubCassette -= rubAmount
            card.amountOfMoney -= rubAmount
            return rubAmount

        case let .eur(amount: eurAmount):
            guard eurAmount <= eurCassette else { // запрошенная сумма больше, чем есть в банкомате
                throw CashMachineError.isEmpty
            }
            guard eurAmount <= card.amountOfMoney else { // запрошенная сумма больше, чем есть на счете
                throw CashMachineError.notEnoughMoney
            }
            // банкомат и счет стали "полегче"
            eurCassette -= eurAmount
            card.amountOfMoney -= eurAmount
            return eurAmount
        }
    }
}

var atm: CashMachine = CashMachine()
let sberCard: Card = Card(holderName: "Джулия Робертс", number: "5500 2200 1288 1655", expirationDate: "12/22", amountOfMoney: 9_000)

let insertCardResult = atm.insertCard(card: sberCard)

switch insertCardResult {
case .failure(.invalidCard):
    print("Карта не действительна")
case .failure(.cantReadCard):
    print("Карта не читается")
case let .success(greatings):
    print(greatings) // Карта принята. Введите пин код
}


// для события банкомат полон вносим больше 1000 Rub или больше 500 Eur
// Правильный пин 1111
let depositCashResult = atm.depositCash(currency: .eur(amount: 500), pinCode: 1111)

if let result = depositCashResult.response {
    print(result)
} else if let error = depositCashResult.error {
    print("Произошла ошибка. \(error.rawValue)")
}



// для события банкомат пуст снимаем больше 10000 Rub
// При больше 9000 руб сработает ошибка недостачно денег на счете
// Правильный пин 1111
do {
    let withdrawCashResult = try atm.wihdrawCash(currency: .rub(amount: 8000), pinCode: 1111)
    print("Ваша сумма \(withdrawCashResult). Заберите деньги. Заберите карту")
} catch CashMachineError.invalidPinCode {
    print("Ошибка. Неправильный пин код")
}catch CashMachineError.isEmpty {
    print("Ошибка. В банкомате недостаточно денег")
}catch CashMachineError.notEnoughMoney {
    print("Ошибка. На счете недостаточно денег")
}


