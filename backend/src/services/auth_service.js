
import User from '../models/User.js';

class AuthService {
    // find user by provider+ providerId or create new; mergr by email if exists
    static async findOrCreate({ provider, providerId, email, name, avatar }) {
        // 1) Try exact match (provider+providerId) 
        let user = await User.findOne({ provider, providerId });
        if (user) return user;
        // 2) Try matching by email (merge accounts)
        if (email) {

            user = await User.findOne({ email });
            if (user) {
                // attach the provider info for future logins 
                user.provider = provider;
                user.providerId = providerId;
                user.avatar = user.avatar || avatar;
                await user.save();
                return user;
            }
        }

        // 3) create a new user 
        user = await User.create({ provider, providerId, email, name, avatar });
        return user;
    }
}


export default AuthService;