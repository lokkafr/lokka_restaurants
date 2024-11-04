return {
    {
        Job = {
            name = 'burgershot',
            label = 'Burgershot',
            grades = {
                { label = 'Employee' },
                { label = 'Manager', accountRole = 'manager' },
                { label = 'CEO', accountRole = 'owner' }
            },
            type = 'restaurant',
            hasAccount = true,
        },
        Stashes = {
            Cooler = {
                slots = 25,
                maxWeight = 125000,
                coords = vec3(-1205.34, -893.81, 14.0),
                size = vec3(1.0, 2.75, 2.0),
                rotation = 35.0,
            },
            ['Hot Plate'] = {
                slots = 25,
                maxWeight = 125000,
                coords = vec3(-1197.7, -894.3, 14.0),
                size = vec3(1, 4.25, 2.0),
                rotation = 34.0,
            },
            ['Left Counter'] = {
                slots = 5,
                maxWeight = 50000,
                coords = vec3(-1196.33, -890.63, 14.0),
                size = vec3(1, 1, 0.5),
                rotation = 35.0,
            },
            ['Center Counter'] = {
                slots = 5,
                maxWeight = 50000,
                coords = vec3(-1194.99, -892.7, 14.0),
                size = vec3(1, 1, 0.5),
                rotation = 35.0,
            },
            ['Right Counter'] = {
                slots = 5,
                maxWeight = 50000,
                coords = vec3(-1193.85, -894.46, 14.0),
                size = vec3(1, 1, 0.5),
                rotation = 35.0,
            },
        },
        Clockin = {
            coords = vec3(-1193.25, -898.0, 14.75),
            size = vec3(0.25, 2.75, 1.0),
            rotation = 305.0,
        },
        Crafting = {
            -- GRILLS
            {
                items = {
                    {
                        name = 'burger',
                        ingredients = {
                            mustard = 1,
                        },
                        duration = 5000,
                        count = 1,
                    },
                },
                zones = {
                    {
                        coords = vec3(-1202.75, -897.25, 14.0),
                        size = vec3(0.5, 1.65, 1.4),
                        rotation = 215.0,
                        distance = 1.5,
                    },
                    {
                        coords = vec3(-1200.35, -900.8, 13.8),
                        size = vec3(0.5, 1.65, 1.4),
                        rotation = 215.0,
                        distance = 1.5,
                    },
                },
            },
            -- DRINKS
            {
                items = {
                    {
                        name = 'sprunk',
                        ingredients = {},
                        duration = 5000,
                        count = 1,
                    },
                },
                zones = {
                    {
                        coords = vec3(-1199.7, -895.5, 14.35),
                        size = vec3(0.8, 2.25, 0.9),
                        rotation = 215.0,
                        distance = 1.5,
                    },
                },
            }
        },
        Registers = {
            {
                coords = vec3(-1196.0, -891.35, 14.0),
                size = vec3(0.45, 0.35, 0.8),
                rotation = 32.0,
            },
            {
                coords = vec3(-1194.59, -893.25, 14.0),
                size = vec3(0.5, 0.3, 0.85),
                rotation = 35.0,
            },
            {
                coords = vec3(-1193.37, -895.22, 14.0),
                size = vec3(0.5, 0.3, 0.85),
                rotation = 35.0,
            },
        },
    }
}