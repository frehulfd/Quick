// MARK: Example Hooks

/**
    An async throwing closure executed before an example is run.
*/
public typealias BeforeExampleAsyncClosure = () async throws -> Void

/**
    An async throwing closure executed before an example is run.
    - Note: Isolated to the MainActor.
*/
public typealias BeforeExampleMainAsyncClosure = @MainActor () async throws -> Void

/**
    A throwing closure executed before an example is run.
 */
public typealias BeforeExampleClosure = @MainActor () throws -> Void

/**
    A closure executed before an example is run.
    This is only used by ObjC.
 */
public typealias BeforeExampleNonThrowingClosure = @MainActor () -> Void

/**
    An async throwing closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
*/
public typealias BeforeExampleWithMetadataAsyncClosure = (_ exampleMetadata: ExampleMetadata) async throws -> Void

/**
    An async throwing closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    - Note: Isolated to the MainActor
*/
public typealias BeforeExampleWithMetadataMainAsyncClosure = @MainActor (_ exampleMetadata: ExampleMetadata) async throws -> Void

/**
    A throwing closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
 */
public typealias BeforeExampleWithMetadataClosure = @MainActor (_ exampleMetadata: ExampleMetadata) throws -> Void

/**
    A closure executed before an example is run. The closure is given example metadata,
    which contains information about the example that is about to be run.
    This is only used by ObjC
 */
public typealias BeforeExampleWithMetadataNonThrowingClosure = @MainActor (_ exampleMetadata: ExampleMetadata) -> Void

/**
    A closure for running an example.
 */
public typealias ExampleClosure = @MainActor () throws -> Void

/**
    An async throwing closure executed after an example is run.
*/
public typealias AfterExampleAsyncClosure = BeforeExampleAsyncClosure

/**
    An async throwing closure executed after an example is run.
    - Note: Isolated to the MainActor
*/
public typealias AfterExampleMainAsyncClosure = BeforeExampleMainAsyncClosure

/**
    A throwing closure executed after an example is run.
*/
public typealias AfterExampleClosure = BeforeExampleClosure

/**
    A closure executed after an example is run.
    This is only used by ObjC
*/
public typealias AfterExampleNonThrowingClosure = BeforeExampleNonThrowingClosure

/**
    An async throwing closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataAsyncClosure = BeforeExampleWithMetadataAsyncClosure

/**
    An async throwing closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
    - Note: Isolated to the MainActor
*/
public typealias AfterExampleWithMetadataMainAsyncClosure = BeforeExampleWithMetadataMainAsyncClosure

/**
    A throwing closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataClosure = BeforeExampleWithMetadataClosure

/**
    A closure executed after an example is run. The closure is given example metadata,
    which contains information about the example that has just finished running.
*/
public typealias AfterExampleWithMetadataNonThrowingClosure = BeforeExampleWithMetadataNonThrowingClosure

/**
    A throwing closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleClosure = @MainActor (_ runExample: @escaping () -> Void) throws -> Void

/**
    A closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleNonThrowingClosure = @MainActor (_ runExample: @escaping () -> Void) -> Void

/**
    A throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataClosure =
@MainActor (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () -> Void) throws -> Void

/**
    A throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataNonThrowingClosure =
@MainActor (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () -> Void) -> Void

/**
    An async throwing closure which wraps an example. The closure must call runExample() exactly once.
*/
public typealias AroundExampleAsyncClosure = (_ runExample: @escaping () async -> Void) async throws -> Void

/**
    An async throwing closure which wraps an example. The closure must call runExample() exactly once.
    - Note: Isolated to the MainActor
*/
public typealias AroundExampleMainAsyncClosure = (_ runExample: @MainActor @escaping () async -> Void) async throws -> Void

/**
    An async throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataAsyncClosure =
    (_ exampleMetadata: ExampleMetadata, _ runExample: @escaping () async -> Void) async throws -> Void

/**
    An async throwing closure which wraps an example. The closure is given example metadata,
    which contains information about the example that the wrapper will run.
    The closure must call runExample() exactly once.
*/
public typealias AroundExampleWithMetadataMainAsyncClosure =
    (_ exampleMetadata: ExampleMetadata, _ runExample: @MainActor @escaping () async -> Void) async throws -> Void

// MARK: Suite Hooks

/**
    An async throwing closure executed before any examples are run.
*/
public typealias BeforeSuiteAsyncClosure = () async throws -> Void

/**
    An async throwing closure executed before any examples are run.
    - Note: Isolated to the MainActor
*/
public typealias BeforeSuiteMainAsyncClosure = @MainActor () async throws -> Void

/**
    A throwing closure executed before any examples are run.
*/
public typealias BeforeSuiteClosure = @MainActor () throws -> Void

/**
    A closure executed before any examples are run.
*/
public typealias BeforeSuiteNonThrowingClosure = @MainActor () -> Void

/**
    An async throwing closure executed after all examples have finished running.
*/
public typealias AfterSuiteAsyncClosure = BeforeSuiteAsyncClosure

/**
    An async throwing closure executed after all examples have finished running.
    - Note: Isolated to the MainActor
*/
public typealias AfterSuiteMainAsyncClosure = BeforeSuiteMainAsyncClosure

/**
    A throwing closure executed after all examples have finished running.
*/
public typealias AfterSuiteClosure = BeforeSuiteClosure

/**
    A closure executed after all examples have finished running.
*/
public typealias AfterSuiteNonThrowingClosure = BeforeSuiteNonThrowingClosure
