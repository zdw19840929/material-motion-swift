/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

/** Attaches a position to a destination on either side of a transition using a spring. */
public class TransitionSpring<T: Zeroable>: Interaction {

  /** The value to which the value stream is expected to write. */
  public let property: ReactiveProperty<T>

  /** The spring governing this interaction. */
  public var spring: Spring<T>

  /** A stream that emits spring values. */
  public var valueStream: MotionObservable<T>

  /** The destination property that destinationStream will write to. */
  public let destination: ReactiveProperty<T>

  /** A stream that writes to the spring's destination when the transition's direction changes. */
  public var destinationStream: MotionObservable<T>

  /** The initial velocity of the spring. */
  public let initialVelocity: ReactiveProperty<T>

  /** The tension configuration of the spring. */
  public let tension: ReactiveProperty<CGFloat>

  /** The friction configuration of the spring. */
  public let friction: ReactiveProperty<CGFloat>

  /**
   - parameter value: The property to be updated by the value stream.
   - parameter back: The destination to which the spring will pull the view when transitioning
                     backward.
   - parameter fore: The destination to which the spring will pull the view when transitioning
                     forward.
   - parameter direction: The spring will change its destination in reaction to this property's
                          changes.
   - parameter springSource: A function capable of creating a spring source.
   */
  public init(property: ReactiveProperty<T>,
              back backwardDestination: T,
              fore forwardDestination: T,
              direction: ReactiveProperty<Transition.Direction>,
              springSource: SpringSource<T>) {
    self.property = property

    self.destination = createProperty(withInitialValue: forwardDestination)
    self.spring = Spring(to: destination, initialValue: property, threshold: 1, source: springSource)

    self.tension = spring.tension
    self.friction = spring.friction
    self.initialVelocity = spring.initialVelocity
    self.destinationStream = direction.stream.destinations(back: backwardDestination,
                                                           fore: forwardDestination)
    self.valueStream = self.spring.valueStream

    property.setValue(direction.value == .forward ? backwardDestination : forwardDestination)
  }

  public func connect(with runtime: MotionRuntime) {
    runtime.write(destinationStream, to: destination)
    runtime.write(valueStream, to: property)
  }
}