# lokka_restaurants
An all-in-one restaurant manager built for ox_core.
## Dependencies
- [ox_core](https://github.com/overextended/ox_core/)
- [ox_lib](https://github.com/overextended/ox_lib/)
- [ox_target](https://github.com/overextended/ox_target/)
## Crafting
I currently have an open draft pull request for ox_inventory that makes the crafting with this script work dynamically with the already pre-built systems. By default, crafting is disabled in this script, but can be enabled through `config/general.lua`. If you enable it, you will need to port the changes over from [this pull request](https://github.com/overextended/ox_inventory/pull/1830) into your ox_inventory.

Once (if) they merge my PR, this step will be removed. Until then, GLHF. You will want to follow the same exact table structure as ox_inventory when adding crafting tables into `config/jobs.lua`. Don't worry about defining the job name as I automatically inject it into the table structure for you.
## Copyright
Copyright © 2024 lokkafr https://github.com/lokkafr

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this program. If not, see https://www.gnu.org/licenses/.