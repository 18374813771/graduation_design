package cn.dhx.webSocket;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(myHandler(), "/websocket.do");
		registry.addHandler(new MyWebSocketHandler(), "/websocket.do")
        .addInterceptors(new HandshakeInterceptor());
	}
	@Bean
    public MyWebSocketHandler myHandler() {
        return new MyWebSocketHandler();
    }
}
