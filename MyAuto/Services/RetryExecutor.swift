//
//  RetryExecutor.swift
//  MyAuto
//
//  Created by Astemir Shibzuhov on 14.08.2024.
//

import Foundation

final class RetryExecutor {
    private var retryQueue: DispatchQueue
    private var retryWorkItem: DispatchWorkItem?
    
    init(queue: DispatchQueue = .global()) {
        self.retryQueue = queue
    }
    
    func execute<T>(retries: Int = 3, delay: TimeInterval = 2.0, task: @escaping (@escaping (Result<T, Error>) -> Void) -> Void, completion: @escaping (Result<T, Error>) -> Void) {
        // Cancel any ongoing retry task
        retryWorkItem?.cancel()

        // Create a new DispatchWorkItem for retrying the task
        retryWorkItem = DispatchWorkItem { [weak self] in
            task { result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    if retries > 0 {
                        print("Task failed with error: \(error). Retrying... \(retries) retries left.")
                        self?.execute(retries: retries - 1, delay: delay, task: task, completion: completion)
                    } else {
                        completion(.failure(error))
                    }
                }
            }
        }

        // Execute the retry task with a delay
        if let workItem = retryWorkItem {
            retryQueue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    
    func cancel() {
        // Cancel the retry work item
        retryWorkItem?.cancel()
    }
}
