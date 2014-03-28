// Copyright (c) 2014 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package org.cef;

/**
 * An abstract adapter class for receiving focus events. 
 * The methods in this class are empty.
 * This class exists as convenience for creating handler objects.
 */
public abstract class CefFocusHandlerAdapter implements CefFocusHandler {

  @Override
  public void onTakeFocus(CefClient client, boolean next) {
    return;
  }

  @Override
  public boolean onSetFocus(CefClient client, FocusSource source) {
    return false;
  }

  @Override
  public void onGotFocus(CefClient client) {
  }
}
