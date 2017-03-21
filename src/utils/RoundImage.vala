/**
* Copyright (c) 2017 SkyzohKey <skyzohkey@konv.im>
*
* MIT License
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**/

using Cairo;

namespace Konv.Gui.Utils {

  /**
   * Adds a closed sub-path rounded rectangle of the given size and border radius to the current path
   * at position (x, y) in user-space coordinates.
   *
   * @param cr a {@link Cairo.Context}
   * @param x the X coordinate of the top left corner of the rounded rectangle
   * @param y the Y coordinate to the top left corner of the rounded rectangle
   * @param width the width of the rounded rectangle
   * @param height the height of the rounded rectangle
   * @param radius the border radius of the rounded rectangle
   */
  public static void cairo_rounded_rectangle (Cairo.Context cr, double x, double y, double width, double height, double radius) {

    cr.move_to (x + radius, y);
    cr.arc (x + width - radius, y + radius, radius, Math.PI * 1.5, Math.PI * 2);
    cr.arc (x + width - radius, y + height - radius, radius, 0, Math.PI * 0.5);
    cr.arc (x + radius, y + height - radius, radius, Math.PI * 0.5, Math.PI);
    cr.arc (x + radius, y + radius, radius, Math.PI, Math.PI * 1.5);
    cr.close_path ();
  }
}
