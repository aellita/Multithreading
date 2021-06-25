import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let timer = DispatchSource.makeTimerSource(queue: .global())
timer.setEventHandler { //обработчик событий
    print("!")
}

timer.schedule(deadline: .now(), repeating: 5)
timer.activate()
