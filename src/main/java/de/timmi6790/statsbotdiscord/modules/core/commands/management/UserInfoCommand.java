package de.timmi6790.statsbotdiscord.modules.core.commands.management;

import de.timmi6790.statsbotdiscord.StatsBot;
import de.timmi6790.statsbotdiscord.modules.command.AbstractCommand;
import de.timmi6790.statsbotdiscord.modules.command.CommandParameters;
import de.timmi6790.statsbotdiscord.modules.command.CommandResult;
import de.timmi6790.statsbotdiscord.modules.core.Rank;
import de.timmi6790.statsbotdiscord.modules.core.UserDb;
import de.timmi6790.statsbotdiscord.modules.setting.AbstractSetting;
import de.timmi6790.statsbotdiscord.utilities.UtilitiesDiscord;
import net.dv8tion.jda.api.entities.User;

import java.util.Map;
import java.util.StringJoiner;
import java.util.stream.Collectors;

public class UserInfoCommand extends AbstractCommand {
    public UserInfoCommand() {
        super("sinfo", "Management", "", "<discordUser>");

        this.setPermission("core.management.sinfo");
        this.setMinArgs(1);
    }

    @Override
    protected CommandResult onCommand(final CommandParameters commandParameters) {
        final User user = this.getDiscordUser(commandParameters, 0);
        final UserDb userDb = UserDb.getOrCreate(user.getIdLong());

        final short commandSpamCache = StatsBot.getCommandManager().getCommandSpamCache().get(user.getIdLong());
        final int activeEmotes = StatsBot.getEmoteReactionManager().getActiveEmotesPerPlayer().getOrDefault(user.getIdLong(), 0);

        final StringJoiner settings = new StringJoiner("\n");
        for (final Map.Entry<AbstractSetting, String> setting : userDb.getStatsMap().entrySet()) {
            settings.add(setting.getKey().getInternalName() + ": " + setting.getKey().parseSetting(setting.getValue()));
        }

        this.sendTimedMessage(commandParameters,
                UtilitiesDiscord.getDefaultEmbedBuilder(commandParameters)
                        .setTitle("User Info")
                        .addField("Command Spam Cache", String.valueOf(commandSpamCache), true)
                        .addField("Active Emotes", String.valueOf(activeEmotes), true)
                        .addField("Shop Points", String.valueOf(userDb.getPoints()), false)
                        .addField("Ranks", userDb.getPrimaryRank() + "[" + userDb.getRanks().stream().map(Rank::getName).collect(Collectors.joining("; ")) + "]", true)
                        .addField("Settings", settings.toString(), false)
                        .addField("User Perms", String.join("\n", userDb.getPermissionNodes()), false),
                90
        );

        return CommandResult.SUCCESS;
    }
}
