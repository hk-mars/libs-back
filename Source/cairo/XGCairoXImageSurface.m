/*
   Copyright (C) 2002 Free Software Foundation, Inc.

   Author: Banlu Kemiyatorn <object at gmail dot com>

   This file is part of GNUstep.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   
   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <Foundation/NSUserDefaults.h>
#include <math.h>
#include "cairo/XGCairoXImageSurface.h"

#define GSWINDEVICE ((gswindow_device_t *)gsDevice)

@implementation XGCairoXImageSurface

+ (CairoSurface *) createSurfaceForDevice: (void *)device
				depthInfo: (CairoInfo *)cairoInfo
{
#define NEWGSWINDEVICE ((gswindow_device_t *)device)
  XGCairoXImageSurface *surface;

  surface = [[self alloc] initWithDevice:NEWGSWINDEVICE];
  
  NSAssert(NEWGSWINDEVICE->buffer, @"FIXME! CairoSurface: Strange, a window doesn't have buffer");
  
  return surface;
#undef NEWGSWINDEVICE
}


- (NSString *) description
{
  return [NSString stringWithFormat: @"<XGCairoXImageSurface %p xr:%p>", self, image];
}

- (id) initWithDevice: (void *)device
{
  /* FIXME format is ignore when Visual isn't NULL
   * Cairo may change this API
   */
  gsDevice = device;
  image = XCreateImage(GSWINDEVICE->display,
		       DefaultVisual(GSWINDEVICE->display,
				     DefaultScreen(GSWINDEVICE->display)),
		       24, ZPixmap, 0, NULL,
		       GSWINDEVICE->xframe.size.width,
		       GSWINDEVICE->xframe.size.height,
		       8, 0);
  image->data = malloc(image->height * image->bytes_per_line);
  NSLog(@"alloc %d %d %d",image->width,image->height,(image->height * image->bytes_per_line));
  
  return self;
}

- (void) setAsTargetOfCairo: (cairo_t *)ct
{
  cairo_set_target_image(ct, image->data, CAIRO_FORMAT_ARGB32, 
			 image->width, image->height, image->width*4);
}

- (NSSize) size
{
  return GSWINDEVICE->xframe.size;
}

@end
