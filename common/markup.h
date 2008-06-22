/*
 * markup.h - markup header
 *
 * Copyright © 2008 Julien Danjou <julien@danjou.info>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

#ifndef AWESOME_COMMON_MARKUP_H
#define AWESOME_COMMON_MARKUP_H

#include "common/buffer.h"

typedef struct
{
    buffer_t text;
    const char **elements;
    const char **elements_sub;
    char ***attribute_names;
    char ***attribute_values;
} markup_parser_data_t;

markup_parser_data_t * markup_parser_data_new(const char **, const char **, ssize_t);
void markup_parser_data_delete(markup_parser_data_t **);
bool markup_parse(markup_parser_data_t *data, const char *, ssize_t);

#endif
// vim: filetype=c:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
