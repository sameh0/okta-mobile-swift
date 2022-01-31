//
// Copyright (c) 2022-Present, Okta, Inc. and/or its affiliates. All rights reserved.
// The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
//
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and limitations under the License.
//

import Foundation

@propertyWrapper
struct Weak<Object: AnyObject> {
    weak var wrappedValue: Object?
    
    init(_ object: Object?) {
        wrappedValue = object
    }
}

@propertyWrapper
struct WeakCollection<Collect, Element> where Collect: RangeReplaceableCollection, Collect.Element == Optional<Element>, Element: AnyObject {
    private var weakObjects = [Weak<Element>]()

    init(wrappedValue value: Collect) { save(collection: value) }

    private mutating func save(collection: Collect) {
        weakObjects = collection.map { Weak($0) }
    }

    var wrappedValue: Collect {
        get { Collect(weakObjects.map { $0.wrappedValue }) }
        set (newValues) { save(collection: newValues) }
    }
}