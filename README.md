# Flutter Development Roadmap: Audio Analysis Project

## Overview
This document serves as a log to outline the key lessons and takeaways I've learned from my Flutter development experience, particularly during my work on a audio analysis project.

## Lessons Learned

### 1. Bridging Native Code for Enhanced Performance

It's feasible to bridge native code (e.g., Swift for iOS or Java/Kotlin for Android) with Flutter to execute specific tasks. This allows for leveraging platform-specific optimizations and can lead to better performance.

- **Advantages**:
  - Enables use of platform-specific features and optimizations.
  - Provides flexibility in combining the best of Flutter and native development.
  
- **Drawbacks**:
  - **Parameter Type Limitations**: When passing data between Flutter and native modules, you're limited by the types of parameters you can pass. This can sometimes necessitate creating intermediate representations or serializers to convert complex data types into something that can be easily passed and then reconstituted on the other side.
  
- **Applications**:
  - Custom algorithms that require optimized performance.
  - Accessing platform-specific hardware or software features.

This drawback further emphasizes the need for careful planning and considerations when deciding to bridge between Flutter and native code. The developer should be well aware of these type constraints and prepare accordingly to ensure smooth data transfer and communication.

### 2. Limitations with Dart's Single-threaded Nature

Dart has a single-threaded approach. While it offers "isolates" for concurrent programming, there are challenges associated with memory usage, particularly when data is being transferred from native to Dart.

- **Challenges**:
  - Dart's single-threaded nature can pose a bottleneck for CPU-intensive tasks.
  - When data is processed by an isolate, it can be instantiated multiple times in memory. For instance, when data comes from a native module and is processed by an isolate, the data might be instantiated thrice, causing potential memory inefficiencies.
  - Even if you define a class as a singleton in one isolate, it won't be the same instance in another isolate because of the separate memory heaps. This behavior is the same in both debug and release modes.
  
- **Potential Solutions**:
  - For computationally intensive tasks, consider processing them natively and passing only the final result to Dart to minimize data transfer.
  - Employ efficient data structures and serialization methods to minimize memory footprint.
  - Continuously monitor memory usage during development to identify potential bottlenecks or inefficiencies.
  
### 3. Understanding `async` and `await` in Dart: A Deep Dive into the Event Loop

#### Event Loop and Single-threaded Model

Both Dart and JavaScript function using an event loop model. To simplify, this means there's a main thread that continuously looks for tasks to execute from a queue. Once it finds a task, it executes it. If there are no tasks, the main thread waits.

#### The Magic of `async` and `await`

Enter the `async` and `await` keywords. They were introduced to simplify working with asynchronous operations, making code appear synchronous even when it's not.

Here's a brief overview:

- **`async`**: Declares a function as asynchronous. It means the function will return a `Future` (or `Promise` in JavaScript terms). It's a placeholder for a value that might not be available yet.
  
- **`await`**: Used within an `async` function, it tells the event loop, "Wait for this asynchronous operation to complete, but don't just sit there. If there are other tasks in the queue, go ahead and execute them."

#### Illusion of Parallelism

When you're working with `async` and `await`, it feels like things are happening in parallel. But in reality, it's a form of multitasking called **cooperative multitasking**. The tasks themselves decide when to give up control.

Let's contrast this with **preemptive multitasking**:

- **Cooperative Multitasking**: Tasks run until they voluntarily yield control, often using mechanisms like `await`. This approach is predictable but relies on tasks being well-behaved and yielding control regularly.
  
- **Preemptive Multitasking**: The system (or operating system) has control. It decides when to pause a task and switch to another, based on various factors. This can result in tasks being interrupted almost any time.

In Dart's event loop model with `async` and `await`, a task that starts will run until completion unless it encounters an `await`. At that point, it says, "I'll wait here. If there's something else to do, go for it." Other tasks can then run during these await pauses.

#### Practical Implications

For developers:

1. **Predictability**: Cooperative multitasking provides predictability. Since tasks are not pre-empted arbitrarily, the sequence of operations is more under the developer's control.
  
2. **Efficiency**: Using `async` and `await` can lead to more efficient code, as the main thread can keep itself busy executing other tasks while waiting for an asynchronous operation to complete.
  
3. **Responsiveness**: In UI development, this model ensures the user interface remains responsive. Heavy computations can be split with `await` allowing UI updates in between.

4. **Careful with Blocking Operations**: It's crucial to avoid long-running synchronous tasks. Since there's a single main thread, any task that doesn't yield (with `await` or otherwise) will block the entire application, leading to unresponsiveness.

### 4. Debug vs. Release Modes in Flutter

Flutter, like many development platforms, offers different modes for building and running applications. These modes are optimized for different phases of the development cycle, from initial development and debugging to final release. Here's a breakdown of the two primary modes: Debug and Release.

#### General Overview

1. **Debug Mode**:
   - **Virtual Machine (VM)**: In debug mode, Flutter runs on a VM (Dart VM). This VM allows for dynamic code updates, which means as you code and save, hot reloading becomes possible.
   - **Assertions**: The VM mode can include assertions to check for issues that shouldn't occur in a correctly functioning app but might be present during development.
   - **Development Tools**: Debug mode also enables a suite of development tools to assist developers. For instance, you can see visual aids like layout boundaries.

2. **Release Mode**:
   - **Ahead-of-Time Compilation (AOT)**: Flutter uses AOT compilation when building your app for release. AOT compilation converts Dart code into native machine code for the platform it's running on, resulting in a much faster execution time compared to the VM.
   - **Optimizations**: The builder also performs tree-shaking to remove unused code, ensuring the smallest possible package size. Additionally, it obfuscates the code, making it harder to reverse engineer.

#### Performance Testing in Debug Mode: A Tricky Affair

When you're running your app in debug mode, you should be wary of performance measurements for several reasons:

1. **Not True Native Execution**: Since the debug version runs on the Dart VM, you're not getting the performance characteristics of native code. This VM introduces overhead, making apps slower than their release counterparts.

2. **Additional Tools & Checks**: Debug mode often includes extra checks, tools, and utilities (like layout boundaries and the widget inspector). These can slow down your app further.

3. **Hot Reload Overhead**: The ability to dynamically inject updated source code into a running Dart VM (hot reload) is fantastic for development productivity, but it's an additional process that doesn't exist in a released app.

Because of these differences, while you can and should fix obvious performance issues in debug mode, you should always validate and test performance in a **profile mode** or the release mode. Profile mode is a middle ground—it's closer to the release performance but with some ability to profile and analyze the app.

In essence, while the debug mode offers powerful tools for development, it is not representative of the real-world performance users will experience. Always make final performance judgments using the release or profile builds.
Sure thing. Let's group everything into a single table:

### Practical tests

Intense processing has about a 10-20% overhead, and in special isolate calls are massively ruined on debug.

| **Test Type** | **Mode**  | **Average Time Taken (ms)** |
|---------------|-----------|-----------------------------|
| Async Execution | Release | 117                         |
| Async Execution | Debug   | 135                         |
| Isolate Calls     | Release | 113                         |
| Isolate Calls     | Debug   | 371                         |

### Performance Analysis

**Problem Definition**:
The algorithm is designed to detect pitches within the frequency spectrum of string instruments 32.7 Hz to 2093.0 Hz

**Algorithm**:
- **Yin Pitch Detection**:
  - Strategy: The primary strategy used in the Yin Pitch Detection algorithm is the Cumulative Mean Normalized Difference Function (CMNDF). It functions by identifying asymmetry in the waveform. The waveform is split into two windows, and the difference between these windows is computed and normalized for different tau values. The algorithm identifies the delay (or tau) which minimizes this difference, providing the pitch or frequency.
  - Complexity: The algorithm typically has a linear time complexity, O(n), where n is the number of samples.

**Audio Recording Configuration**:
- **Sample Rate**: 48,000 Hz (or 48 kHz)
- **Channels**: Mono
- **Bit Depth**: 16 bits PCM
- **Frame Time**: 1 second

Given these configurations, the result of streaming data is approximately 93.75 KB for every 1-second frame of audio recorded.

**Execution Timings on Xiaomi Redmi Note 8, worst case scenario of the algorithm**:

| Configuration | Avg. Time Taken |
|----------------------|------------|
| Flutter Side useIsolates = true, useTopLevelFunction = true | ~113 ms |
| Flutter Side useIsolates = false, useTopLevelFunction = true | ~111 ms |
| Flutter Side useIsolates = false, useTopLevelFunction = false | ~113 ms |
| Native Execution | 1 ms |

In conclusion, while Flutter offers fantastic tools and capabilities for building cross-platform applications with a single codebase, there are specific scenarios, especially those requiring high-performance computations, where native implementations are irreplaceably efficient.
