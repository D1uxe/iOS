
/*                                       Урок 6. Продвинутое ООП
 1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
 2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
 3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.
 */

struct Queue<T> {
    // MARK: - Private Properties

    private var elements = Array<T>()

    // MARK: - Public Properties

    /// The number of elements in the queue
    var count: Int {
        return elements.count
    }

    // MARK: - Public Constructors

    init(_ queueLiteral: T...) {
        for value in queueLiteral {
            elements.append(value)
        }
    }

    init(_ array: [T]) {
        elements = array
    }

    // MARK: - Subscripts

    subscript(index: Int) -> T? {
        // assert(index >= 0 && index < count, "Index out of range") //с ошибкой правдоподобней
        guard index >= 0 && index < count else { return nil }
        return elements[index]
    }

    // MARK: - Public Methods

    /// Adds an item to the end of the queue
    /// - Parameter newElement: the element to be added to the end of the queue
    mutating func enqueue(_ newElement: T) {
        elements.append(newElement)
    }

    /// Returns and removes the first item of the queue
    /// - Returns: the first element of the queue, otherwise nil
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }

    /// Returns the first item of the queue without removing it
    /// - Returns: the first element of the queue, otherwise nil
    mutating func peek() -> T? {
        return elements.first
    }

    /// Returns an queue containing, in order, the elements of the sequence that satisfy the given predicate
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: Returns an queue
    mutating func filtered(_ isIncluded: (T) -> Bool) -> Self {
        var filtredElements = [T]()
        for item in elements {
            if isIncluded(item) {
                filtredElements.append(item)
            }
        }
        return Queue<T>.self.init(filtredElements)
    }

    /// Filter the collection in place, using the given predicate as the comparison
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    mutating func filter(_ isIncluded: (T) -> Bool) {
        elements = elements.filter(isIncluded)
    }

    /// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: true if the sequence contains an element that satisfies predicate; otherwise, false.
    mutating func contains(where predicate: (T) -> Bool) -> Bool {
        for item in elements {
            if predicate(item) {
                return true
            }
        }
        return false
    }
}



var queue = Queue<Int>(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
print("Изначальная очередь: \(queue). Количество элементов \(queue.count)")

queue[1]
queue[-1]
queue[15]


queue.enqueue(11)
queue.enqueue(12)
print("Очередь после добавления элементов: \(queue). Количество элементов \(queue.count)")


var tempQueue = queue.dequeue()
tempQueue = queue.dequeue()
print("Очередь после извлечения элементов: \(queue). Количество элементов \(queue.count)")


tempQueue = queue.peek()
print("Очередь после метода peek: \(queue). Количество элементов \(queue.count)")


queue.contains(where: { (x) -> Bool in x == 7 })
queue.contains(where: { (x) -> Bool in x == 70 })


var filteredQueue = queue.filtered({ $0 % 2 == 0 })
print("Отфильтрованная очередь с четными элементами: \(filteredQueue).")
print("Оригинальная очередь после метода filtered не изменилась: \(queue). Количество элементов \(queue.count)")


queue.filter({ $0 % 2 == 0 })
print("Оригинальная очередь с четными элементами после метода filter: \(queue). Количество элементов \(queue.count)")



var stringQueue = Queue<String>("first", "second")
stringQueue.enqueue("third")
stringQueue.enqueue("4")

var tempStrQueue = stringQueue.peek()

stringQueue.count

stringQueue.filter({ $0.count < 6 })

stringQueue

stringQueue.dequeue()


