//
//  File.swift
//  
//
//  Created by Astemir Shibzuhov on 18.09.2024.
//

import Combine

public extension Publisher {
    static func just(_ output: Output) -> AnyPublisher<Self.Output, Self.Failure> {
        return Just(output).setFailureType(to: self.Failure).eraseToAnyPublisher()
    }
    
    static func empty() -> AnyPublisher<Self.Output, Self.Failure> {
        return Empty(completeImmediately: true).setFailureType(to: self.Failure).eraseToAnyPublisher()
    }
    
    static func fail(error: Self.Failure) -> AnyPublisher<Self.Output, Self.Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
    
    func catchAndReturn(_ output: Self.Output) -> Publishers.Catch<Self, AnyPublisher<Self.Output, Never>> {
        self.catch { _ in Just(output).eraseToAnyPublisher() }
    }
    
    func catchAndReturnEmpty() -> Publishers.Catch<Self, AnyPublisher<Self.Output, Never>> {
        self.catch { _ in Empty().eraseToAnyPublisher() }
    }
    
    func catchAndReturnResult() -> AnyPublisher<Result<Self.Output, Error>, Never> {
        self.map({
            return Result.success($0)
        })
        .catch({ error in
            return Just(Result.failure(error))
        })
            .eraseToAnyPublisher()
    }
    
    func sink(receiveError: ((Self.Failure) -> Void)? = nil,
              receiveValue: ((Self.Output) -> Void)? = nil,
              receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil) -> AnyCancellable {
        return self.sink { completion in
            receiveCompletion?(completion)
            if case .failure(let error) = completion {
                receiveError?(error)
            }
        } receiveValue: { value in
            receiveValue?(value)
        }
    }
    
    func sink(receiveValue: ((Self.Output) -> Void)? = nil,
              receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil) -> AnyCancellable {
        return self.sink { completion in
            receiveCompletion?(completion)
            if case .failure(let error) = completion {
                return
            }
        } receiveValue: { value in
            receiveValue?(value)
        }
    }
}
