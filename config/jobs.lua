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
            Fridge = {
                slots = 25,
                maxWeight = 125000,
                coords = vec3(-55.47, -1097.09, 26.0),
                size = vec3(1.05, 1.35, 1.3),
                rotation = 88.75,
            },
            Storage = nil,
            Freezer = nil,
        },
        Clockin = {
            coords = vec3(-58.0, -1098.0, 21.0),
            size = vec3(1.05, 1.35, 1.3),
            rotation = 88.75,
        },
        Crafting = {
            {
                items = {
                    {
                        name = 'testburger',
                        ingredients = {
                            bandage = 1,
                        },
                        duration = 5000,
                        count = 1,
                    },
                },
                points = {
                    vec3(-58.0, -1098.0, 26.0),
                },
                zones = {
                    {
                        coords = vec3(-58.0, -1098.0, 26.0),
                        size = vec3(1.05, 1.35, 1.3),
                        distance = 1.5,
                        rotation = 88.75,
                    },
                },
            }
        },
    }
}