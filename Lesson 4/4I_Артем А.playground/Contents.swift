import Foundation
/*
 1. Описать класс Car c общими свойствами автомобилей и пустым методом действия по аналогии с прошлым заданием.
 2. Описать пару его наследников trunkCar и sportСar. Подумать, какими отличительными свойствами обладают эти автомобили. Описать в каждом наследнике специфичные для него свойства.
 3. Взять из прошлого урока enum с действиями над автомобилем. Подумать, какие особенные действия имеет trunkCar, а какие – sportCar. Добавить эти действия в перечисление.
 4. В каждом подклассе переопределить метод действия с автомобилем в соответствии с его классом.
 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
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


class Car {
    
    // MARK: - Public Properties

    var carBrand: String = ""
    var yearOfManufacture: String = ""
    var trunkVolume: Float = 0.0
    var speed: Int = 0
    var windowState: WindowState = .closed
    var engineState: EngineState = .stopped

    // MARK: - Constructors

    init(carBrand: String, yearOfManufacture: String) {
           self.carBrand = carBrand
           self.yearOfManufacture = yearOfManufacture
       }
 

    // MARK: - Public Methods

    func window(do windowState: WindowState) {
        self.windowState = windowState
    }

    
    func engine(do engineState: EngineState) {
        self.engineState = engineState
    }
    
    func useAutoParking() {}
    
    func info() {}
}




class SportCar: Car {
    
    // MARK: - Public Properties

    private var _trunkVolume: Float = 2.0
    override var trunkVolume: Float {
        get {
            return _trunkVolume
        }
        set {
            if newValue > 5.0 {
                print("Это не грузовик, такой объем недопустим")
                _trunkVolume = 5.0
            }
        }
    }

    override var engineState: EngineState {
        willSet {
            if newValue == .started {
                print("Двигатель \(carBrand) сейчас запустится")
            } else {
                print("Двигатель \(carBrand) сейчас остановится")
            }
        }
        didSet {
            if oldValue == .stopped {
                print("Двигатель \(carBrand) запущен")
            } else {
                print("Двигатель \(carBrand) остановлен")
            }
        }
    }

    var NOS: Bool  // Nitrous Oxide System :)

    
    // MARK: - Constructors
    
    init(carBrand: String, yearOfManufacture: String, NOS: Bool) {
        self.NOS = NOS
        super.init(carBrand: carBrand, yearOfManufacture: yearOfManufacture)
    }
    
    
    // MARK: - Public Methods

    func useNOS() {
        if NOS {
            speed = speed * 2
            print("Скорость увеличена до \(speed)")
        } else {
            print("Спорткар \(carBrand) не оснащен системой закиси азота")
        }
    }
    
    override func useAutoParking() {
        print("Включаю автопарковку...")
        print("Парковка звершена, можно выходить")
    }
}




class TrunkCar: Car {
    
    
    // MARK: - Public Properties

   override var windowState: WindowState {
        didSet {
            if oldValue == .closed {
                print("Окна \(carBrand) открыты ")
            } else {
                print("Окна \(carBrand) закрыты")
            }
        }
    }
    
    var trailler: Bool

    
    // MARK: - Constructors
    
    init(carBrand: String, yearOfManufacture: String, trunkVolume: Float, trailler: Bool) {
        self.trailler = trailler
        super.init(carBrand: carBrand, yearOfManufacture: yearOfManufacture)
        super.trunkVolume = trunkVolume
    }
    
    
    // MARK: - Public Methods

    override func useAutoParking() {
        print("Авто парковка не установлена, придется по зеркалам :)")

    }
    
   override func info() {
        print("""
        Состояние грузовика: \(carBrand):
        Год производства: \(yearOfManufacture)
        Текущая скорость: \(speed) км/ч
        Объем кузова: \(trunkVolume)
        Состояние окон: \(windowState.rawValue)
        Состояние двигателя: \(engineState.rawValue)
        Прицеп: \(trailler == true ? "да" : "нет")
        """)
    }
}



var ferrari: SportCar = SportCar(carBrand: "Ferrari", yearOfManufacture: "2016", NOS: true)

ferrari.engine(do: .started)
print("Текущая скорость: \(ferrari.speed) км/ч")
ferrari.speed = 120
print("Текущая скорость: \(ferrari.speed) км/ч")
ferrari.useNOS()
print("Текущая скорость после закиси азота: \(ferrari.speed) км/ч")
print("Состояние окон: \(ferrari.windowState.rawValue) ")
ferrari.windowState = .opened
print("Состояние окон: \(ferrari.windowState.rawValue) ")
ferrari.useAutoParking()
ferrari.engineState = .stopped
print("Текущий объем багажника: \(ferrari.trunkVolume) м3")



print("\n========Bugatti==========")
var bugatti: SportCar = SportCar(carBrand: "Bugatti Vieron", yearOfManufacture: "2021", NOS: false)

print("Состояние двигателя \(bugatti.carBrand) \(bugatti.engineState.rawValue)")
bugatti.engineState = .started
print("Состояние двигателя \(bugatti.engineState.rawValue)")
bugatti.speed = 100
print("Текущая скорость: \(bugatti.speed) км/ч")
bugatti.useNOS()
print("Текущая скорость: \(bugatti.speed) км/ч")
print("Текущий объем багажника: \(bugatti.trunkVolume) м3")
bugatti.trunkVolume = 10.0
print("Текущий объем багажника: \(bugatti.trunkVolume) м3")
bugatti.engine(do: .stopped)



print("\n========Volvo Trunk ==========")
var volvo: TrunkCar = TrunkCar(carBrand: "Volvo Trunk", yearOfManufacture: "2010", trunkVolume: 5000.0, trailler: true)

print("Состояние окон: \(volvo.windowState.rawValue) ")
volvo.window(do: .opened)
print("Состояние окон: \(volvo.windowState.rawValue) ")
volvo.useAutoParking()



print("\n======== БелАЗ ==========")
var belaz: TrunkCar = TrunkCar(carBrand: "БелАЗ", yearOfManufacture: "2020", trunkVolume: 100500.5, trailler: false)

belaz.info()
