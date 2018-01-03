//
//  AsyncHelper.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/5/31.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import UIKit

public func main_async(_ task: @escaping () -> Void) {
    if Thread.current.isMainThread {
        task()
    } else {
        DispatchQueue.main.async(execute: task)
    }
}

public func main_async(delay: TimeInterval, task: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
}

public func main_sync(_ task: () -> Void) {
    if Thread.current.isMainThread {
        task()
    } else {
        DispatchQueue.main.sync(execute: task)
    }
}

public func back_async(_ task: @escaping () -> Void) {
    DispatchQueue.global().async(execute: task)
}

public func back_async(delay: TimeInterval, task: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: task)
}

public func back_sync(_ task: () -> Void) {
    DispatchQueue.global().sync(execute: task)
}

// helpful wrapper for making async calls
public func async(queue: DispatchQueue = DispatchQueue.global(), work: @escaping () -> Void) {
    queue.async(execute: work)
}

// helpful wrapper for joining the main thread
public func async_main(_ work: @escaping () -> Void) {
    if !Thread.current.isMainThread {
        DispatchQueue.main.async(execute: work)
    } else {
        work()
    }
}

// will lock a mutex on the given object
public func synchronized(_ on: AnyObject, cb: () -> Void) {
    objc_sync_enter(on)
    cb()
    objc_sync_exit(on)
}

public func delay(_ seconds: Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping () -> Void) -> DispatchWorkItem {
    let work = DispatchWorkItem(block: closure)
    queue.asyncAfter(wallDeadline: .now() + seconds, execute: work)
    return work
}
