package de.timmi6790.statsbotdiscord.modules.mineplexstats.commands.debug;

import de.timmi6790.statsbotdiscord.StatsBot;
import de.timmi6790.statsbotdiscord.modules.command.AbstractCommand;
import de.timmi6790.statsbotdiscord.modules.command.CommandParameters;
import de.timmi6790.statsbotdiscord.modules.command.CommandResult;
import de.timmi6790.statsbotdiscord.modules.mineplexstats.MineplexStatsModule;
import de.timmi6790.statsbotdiscord.utilities.UtilitiesDiscord;
import net.dv8tion.jda.api.utils.MarkdownUtil;

public class ReloadDataCommand extends AbstractCommand {
    public ReloadDataCommand() {
        super("sReload", "Debug", "", "[data]", "sr");

        this.setMinArgs(1);
        this.setPermission("mineplexstats.debug.reload");
    }

    @Override
    protected CommandResult onCommand(final CommandParameters commandParameters) {
        final MineplexStatsModule module = (MineplexStatsModule) StatsBot.getModuleManager().getModule(MineplexStatsModule.class);

        final String data = commandParameters.getArgs()[0];
        switch (data.toLowerCase()) {
            case "javagame":
                module.loadJavaGames();
                break;

            case "javagroup":
                module.loadJavaGroups();
                break;

            case "bedrockgame":
                module.loadBedrockGames();
                break;

            default:
                this.sendTimedMessage(
                        commandParameters,
                        UtilitiesDiscord.getDefaultEmbedBuilder(commandParameters)
                                .setTitle("Incorrect data type")
                                .setDescription(MarkdownUtil.monospace(data) + " is not a valid type.\n" +
                                        "[javaGame, javaGroup, bedrockGame]"),
                        90
                );
                return CommandResult.INVALID_ARGS;
        }

        this.sendTimedMessage(
                commandParameters,
                UtilitiesDiscord.getDefaultEmbedBuilder(commandParameters)
                        .setTitle("Reloaded data")
                        .setDescription("Reloaded " + MarkdownUtil.monospace(data)),
                90
        );
        return CommandResult.SUCCESS;
    }
}
