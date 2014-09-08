package io.undertow.conduits;

import io.undertow.server.HttpServerExchange;
import io.undertow.util.ConduitFactory;
import org.xnio.conduits.StreamSinkConduit;

import java.util.zip.CRC32;
import java.util.zip.Deflater;

/**
 * @author Stuart Douglas
 */
public class GzipStreamSinkConduit extends DeflatingStreamSinkConduit {

    /*
     * GZIP header magic number.
     */
    private static final  int GZIP_MAGIC = 0x8b1f;

    /**
     * CRC-32 of uncompressed data.
     */
    protected CRC32 crc = new CRC32();

    public GzipStreamSinkConduit(ConduitFactory<StreamSinkConduit> conduitFactory, HttpServerExchange exchange) {
        super(conduitFactory, exchange, Deflater.DEFAULT_COMPRESSION);
        writeHeader();
    }

    private void writeHeader() {
        currentBuffer.getResource().put(new byte[]{
                (byte) GZIP_MAGIC,        // Magic number (short)
                (byte) (GZIP_MAGIC >> 8),  // Magic number (short)
                Deflater.DEFLATED,        // Compression method (CM)
                0,                        // Flags (FLG)
                0,                        // Modification time MTIME (int)
                0,                        // Modification time MTIME (int)
                0,                        // Modification time MTIME (int)
                0,                        // Modification time MTIME (int)
                0,                        // Extra flags (XFLG)
                0                         // Operating system (OS)
        });
    }

    @Override
    protected void preDeflate(byte[] data) {
        crc.update(data);
    }

    @Override
    protected byte[] getTrailer() {
        byte[] ret = new byte[8];
        int checksum = (int) crc.getValue();
        int total = deflater.getTotalIn();
        ret[0] = (byte) ((checksum) & 0xFF);
        ret[1] = (byte) ((checksum >> 8) & 0xFF);
        ret[2] = (byte) ((checksum >> 16) & 0xFF);
        ret[3] = (byte) ((checksum >> 24) & 0xFF);
        ret[4] = (byte) ((total) & 0xFF);
        ret[5] = (byte) ((total >> 8) & 0xFF);
        ret[6] = (byte) ((total >> 16) & 0xFF);
        ret[7] = (byte) ((total >> 24) & 0xFF);
        return ret;
    }
}
