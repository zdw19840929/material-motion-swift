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

import UIKit

public class ReactiveUIView {
  public let view: UIView

  /** A property representing the view's .isUserInteractionEnabled value. */
  public lazy var isUserInteractionEnabled: ReactiveProperty<Bool> = {
    let view = self.view
    return ReactiveProperty(initialValue: view.isUserInteractionEnabled,
                            write: { view.isUserInteractionEnabled = $0 })
  }()

  /** A property representing the view's .alpha value. */
  public lazy var alpha: ReactiveProperty<CGFloat> = {
    let view = self.view
    return ReactiveProperty(initialValue: view.alpha, write: { view.alpha = $0 })
  }()

  /** A property representing the view's .center value. */
  public lazy var center: ReactiveProperty<CGPoint> = {
    let view = self.view
    return ReactiveProperty(initialValue: view.center, write: { view.center = $0 })
  }()

  /** A property representing the view's .center.x value. */
  public lazy var centerX: ReactiveProperty<CGFloat> = {
    let center = self.center
    return ReactiveProperty(initialValue: center.value.x,
                            write: { var point = center.value; point.x = $0; center.value = point })
  }()

  /** A property representing the view's .center.y value. */
  public lazy var centerY: ReactiveProperty<CGFloat> = {
    let center = self.center
    return ReactiveProperty(initialValue: self.center.value.y,
                            write: { var point = center.value; point.y = $0; center.value = point })
  }()

  public lazy var reactiveLayer: ReactiveCALayer = {
    return self.runtime?.get(self.view.layer) ?? ReactiveCALayer(self.view.layer)
  }()

  init(_ view: UIView, runtime: MotionRuntime) {
    self.view = view
    self.runtime = runtime
  }

  private weak var runtime: MotionRuntime?
}
