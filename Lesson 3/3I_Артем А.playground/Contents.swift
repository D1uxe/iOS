import Foundation
/*
 1. Описать несколько структур – любой легковой автомобиль SportCar и любой грузовик TrunkCar.
 2. Описать в каждом наследнике специфичные для него свойства.Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника. (Указать как схожие свойства структур, так и отличные для каждого вида авто. Можно добавить свои любые)
 3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема. (Использовать свой тип enum по возможности, а не использовать тип Bool)
 4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия. (Написать такой метод, в который можно передать состояние чего-либо, например двигателя. И состояние двигателя структуры поменяется на переданное значение)
 5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
 6. Вывести значения свойств экземпляров в консоль.
 */

enum WindowState: String {
    case opened
    case closed = "закрыты"
}

enum EngineState: String {
    case started = "заведен"
    case stopped = "не заведен"
}

protocol Car {
    
    // MARK: - Public Properties

    var carBrand: String { get set }
    var yearOfManufacture: String { get set }
    var trunkVolume: Float { get set }
    var speed: Int { get }
    var windowState: WindowState { get set }
    var engineState: EngineState { get set }

    // MARK: - Public Methods

    mutating func window(do windowStae: WindowState) -> Void
    mutating func engine(do engineState: EngineState) -> Void
}

extension Car {
    mutating func window(do windowStae: WindowState) {
        windowState = windowState
    }

    mutating func engine(do engineState: EngineState) {
        self.engineState = engineState
    }
}

struct SportCar: Car {
    
    // MARK: - Public Properties

    var carBrand: String

    var yearOfManufacture: String
    private var _trunkVolume: Float = 0.0
    var trunkVolume: Float {
        get { // Без доп приватной переменной ругается на get. Но если сделать такую приватную переменную (как сейчас) и оставить конструктор по умолчанию, то он просит ее инициализировать, но почему если она приватная и недолжна быть доступна из вне. А вот если сделать свой конструктор, то все норм(как сейчас) Как тогда правильно делать проверку на допустимость значений? Может рассмотрим на уроке этот вопрос, если долго писать? Я напомню вначале
            return _trunkVolume
        }
        set {
            if newValue > 5.0 {
                print("Это не грузовик, такой объем недопустим")
                _trunkVolume = 5.0
            }
        }
    }

    var speed: Int

    var windowState: WindowState

    var engineState: EngineState {
        willSet {
            if newValue == .started {
                print("Двигатель \(self.carBrand) сейчас запустится")
            } else {
                print("Двигатель \(self.carBrand) сейчас остановится")
            }
        }
        didSet {
            if oldValue == .stopped {
                print("Двигатель \(self.carBrand) запущен")
            } else {
                print("Двигатель \(self.carBrand) остановлен")
            }
        }
    }

    var NOS: Bool // Nitrous Oxide System :)

    // MARK: - Constructors

    init(carBrand: String, yearOfManufacture: String, speed: Int, trunkVolume: Float, windowState: WindowState, engineState: EngineState, NOS: Bool) {
        self.carBrand = carBrand
        self.yearOfManufacture = yearOfManufacture
        self._trunkVolume = trunkVolume
        self.speed = speed
        self.windowState = windowState
        self.engineState = engineState
        self.NOS = NOS
    }

    init(carBrand: String, yearOfManufacture: String, NOS: Bool) {
        self.carBrand = carBrand
        self.yearOfManufacture = yearOfManufacture
        self.speed = 0
        self.windowState = .closed
        self.engineState = .stopped
        self.NOS = NOS
        _trunkVolume = 2.0
    }

    // MARK: - Public Methods

    mutating func useNOS() {
        if NOS {
            self.speed = self.speed * 2
            print("Скорость увеличена до \(speed)")
        } else {
            print("Спорткар \(self.carBrand) не оснащен системой закиси азота")
        }
    }
}

struct TrunkCar: Car {
    
    // MARK: - Public Properties

    var carBrand: String
    var yearOfManufacture: String
    var trunkVolume: Float
    var speed: Int
    var windowState: WindowState {
        didSet {
            if oldValue == .closed {
                print("Окна \(self.carBrand) открыты ")
            } else {
                print("Окна \(self.carBrand) закрыты")
            }
        }
    }

    var engineState: EngineState

    var trailler: Bool

    // MARK: - Public Methods

    func info() {
        print("""
        Состояние грузовика \(self.carBrand):
        Год производства: \(self.yearOfManufacture)
        Текущая скорость: \(self.speed)
        Объем кузова: \(self.trunkVolume)
        Состояние окон: \(self.windowState.rawValue)
        Состояние двигателя: \(self.engineState.rawValue)
        Прицеп: \(trailler == true ? "да" : "нет")
        """)
    }
}




var ferrari: SportCar = SportCar(carBrand: "Ferrari", yearOfManufacture: "2016", speed: 200, trunkVolume: 1.5, windowState: .closed, engineState: .stopped, NOS: true)

ferrari.engine(do: .started)
print("Текущая скорость: \(ferrari.speed)")
ferrari.useNOS()
print("Текущая скорость: \(ferrari.speed)")
print("Состояние окон: \(ferrari.windowState.rawValue) ")
ferrari.windowState = .opened
print("Состояние окон: \(ferrari.windowState.rawValue) ")
ferrari.engineState = .stopped
print("Текущий объем багажника: \(ferrari.trunkVolume)")

print("\n========Bugatti==========")
var bugatti: SportCar = SportCar(carBrand: "Bugatti Vieron", yearOfManufacture: "2021", NOS: false)

print("Состояние двигателя \(bugatti.carBrand) \(bugatti.engineState.rawValue)")
bugatti.engineState = .started
print("Состояние двигателя \(bugatti.engineState.rawValue)")
bugatti.speed = 100
print("Текущая скорость: \(bugatti.speed)")
bugatti.useNOS()
print("Текущая скорость: \(bugatti.speed)")
print("Текущий объем багажника: \(bugatti.trunkVolume)")
bugatti.trunkVolume = 10.0
print("Текущий объем багажника: \(bugatti.trunkVolume)")
bugatti.engine(do: .stopped)

print("\n========Volvo Trunk ==========")

var volvo: TrunkCar = TrunkCar(carBrand: "Volvo Trunk", yearOfManufacture: "2010", trunkVolume: 5000.0, speed: 100, windowState: .closed, engineState: .stopped, trailler: true)

print("Состояние окон: \(volvo.windowState.rawValue) ")
volvo.window(do: .opened)
print("Состояние окон: \(volvo.windowState.rawValue) ")

print("\n======== БелАЗ ==========")
var belaz: TrunkCar = TrunkCar(carBrand: "БелАЗ", yearOfManufacture: "2020", trunkVolume: 100500.5, speed: 60, windowState: .closed, engineState: .stopped, trailler: false)

belaz.info()
