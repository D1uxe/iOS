import Foundation
/*                                         Урок 5. ООП
 1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.
 2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).
 3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.
 4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.
 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
 6. Вывести сами объекты в консоль.
 */

enum WindowState: String {
    case opened
    case closed = "закрыты"
}

enum EngineState: String {
    case started = "заведен"
    case stopped = "не заведен"
}

// I от Interface, ни разу в документации Swift не видел. Наверное принято какое-то другое. И как всегда какое угодно, но лишь бы не как у всех принято, что-то вроде: -ing, -able. Протокол Caring или Carable =)
protocol ICar: class {

    // MARK: - Public Properties
    
    var carBrand: String { get set }
    var yearOfManufacture: String { get set }
    var trunkVolume: Float { get set }
    var speed: Int { get }
    var windowState: WindowState { get set }
    var engineState: EngineState { get set }

    // MARK: - Public Methods
    
    func window(do windowStae: WindowState)
    func engine(do engineState: EngineState)
}



extension ICar {
    
    func window(do windowState: WindowState) {
        self.windowState = windowState
    }

    func engine(do engineState: EngineState) {
        self.engineState = engineState
    }
}

class SportCar: ICar {

    //MARK: - Nested Types
    
    enum NitrousOxideSystemS: String {
        case yes = "Да"
        case no = "Нет"
    }
    
    
    // MARK: - Public Properties
    
    var carBrand: String

    var yearOfManufacture: String
    
    private var _trunkVolume: Float = 0.0
    var trunkVolume: Float {
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

    var NOS: NitrousOxideSystemS // Nitrous Oxide System :)
    
    
    // MARK: - Constructors
    
    init(carBrand: String, yearOfManufacture: String, speed: Int, trunkVolume: Float, windowState: WindowState, engineState: EngineState, NOS: NitrousOxideSystemS) {
        
        self.carBrand = carBrand
        self.yearOfManufacture = yearOfManufacture
        self._trunkVolume = trunkVolume
        self.speed = speed
        self.windowState = windowState
        self.engineState = engineState
        self.NOS = NOS
    }

   convenience init(carBrand: String, yearOfManufacture: String, NOS: NitrousOxideSystemS) {
    
    self.init(carBrand: carBrand,
              yearOfManufacture: yearOfManufacture,
              speed: 0,
              trunkVolume: 2,
              windowState: .closed,
              engineState: .stopped,
              NOS: NOS)
    _trunkVolume = 2.0
    
    }

    
    // MARK: - Public Methods
    
     func useNOS() {
        if self.NOS == .yes {
            self.speed = self.speed * 2
            print("Скорость увеличена до \(self.speed)")
        } else {
            print("Спорткар \(self.carBrand) не оснащен системой закиси азота")
        }
    }
}


extension SportCar: CustomStringConvertible {
    var description: String {
        return """

        Спорткар \(self.carBrand):
        Год производства: \(self.yearOfManufacture)
        Текущая скорость: \(self.speed)
        Объем багажника: \(self.trunkVolume)
        Состояние окон: \(self.windowState.rawValue)
        Состояние двигателя: \(self.engineState.rawValue)
        Система закиси азота: \(self.NOS.rawValue)
        """
    }
}



class TrunkCar: ICar {

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

    var trailer: Bool

    
    // MARK: - Constructors
    
    init(carBrand: String, yearOfManufacture: String, speed: Int, trunkVolume: Float, windowState: WindowState, engineState: EngineState, trailer: Bool) {
        
        self.carBrand = carBrand
        self.yearOfManufacture = yearOfManufacture
        self.trunkVolume = trunkVolume
        self.speed = speed
        self.windowState = windowState
        self.engineState = engineState
        self.trailer = trailer
    }

    convenience init(carBrand: String, yearOfManufacture: String, trunkVolume: Float,  trailer: Bool) {
    
    self.init(carBrand: carBrand,
              yearOfManufacture: yearOfManufacture,
              speed: 0,
              trunkVolume: trunkVolume,
              windowState: .closed ,
              engineState: .stopped,
              trailer: trailer)
    }
    
    
    // MARK: - Public Methods
    
    func info() {
        print("""
        Состояние грузовика \(self.carBrand):
        Год производства: \(self.yearOfManufacture)
        Текущая скорость: \(self.speed)
        Объем кузова: \(self.trunkVolume)
        Состояние окон: \(self.windowState.rawValue)
        Состояние двигателя: \(self.engineState.rawValue)
        Прицеп: \(self.trailer == true ? "да" : "нет")
        """)
    }
}

extension TrunkCar: CustomStringConvertible {
    
    var description: String {
        return """

        Грузовик \(self.carBrand):
        Год производства: \(self.yearOfManufacture)
        Текущая скорость: \(self.speed)
        Объем кузова: \(self.trunkVolume)
        Состояние окон: \(self.windowState.rawValue)
        Состояние двигателя: \(self.engineState.rawValue)
        Прицеп: \(self.trailer == true ? "да" : "нет")
        """
    }
}


var ferrari: SportCar = SportCar(carBrand: "Ferrari", yearOfManufacture: "2016", speed: 200, trunkVolume: 1.5, windowState: .closed, engineState: .stopped, NOS: .yes)

ferrari.engine(do: .started)
print("Текущая скорость: \(ferrari.speed)")
ferrari.useNOS()
print("Текущая скорость: \(ferrari.speed)")
print("Состояние окон: \(ferrari.windowState.rawValue) ")
ferrari.windowState = .opened
print("Состояние окон: \(ferrari.windowState.rawValue) ")
ferrari.engineState = .stopped
print("Текущий объем багажника: \(ferrari.trunkVolume)")

print(ferrari)



print("\n========Bugatti==========")
var bugatti: SportCar = SportCar(carBrand: "Bugatti Vieron", yearOfManufacture: "2021", NOS: .no)

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
var volvo: TrunkCar = TrunkCar(carBrand: "Volvo Trunk", yearOfManufacture: "2010", speed: 100, trunkVolume: 5000.0, windowState: .closed, engineState: .stopped, trailer: true)

print("Состояние окон: \(volvo.windowState.rawValue) ")
volvo.window(do: .opened)
print("Состояние окон: \(volvo.windowState.rawValue) ")



print("\n======== БелАЗ ==========")
var belaz: TrunkCar = TrunkCar(carBrand: "БелАЗ", yearOfManufacture: "2020", trunkVolume: 100500.5, trailer: false)

belaz.speed = 60

print(belaz)
